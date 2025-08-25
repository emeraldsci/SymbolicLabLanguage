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
				(* Call the function again since theoretically after the first call we should have updated all the test protocols to ComputationsOutStanding->False, so we return just the one that is still outstanding *)
				updateParallelComputationFields[],
				(* check to see if the manifold kernel was properly swapped out if we hit an error with number 2 *)
				Download[
					Object[Protocol, NMR, "Test protocol 4 for updateParallelComputationFields tests" <> $SessionUUID],
					ParallelComputations[ManifoldKernel]
				]
			},
			{
				{
					{False, {ObjectP[Object[Software, ManifoldKernelCommand, "Test ManifoldKernelCommand Job 2 for updateParallelComputationFields tests" <> $SessionUUID]], ObjectP[Object[Notebook, Job, "Test Job 2 for updateParallelComputationFields tests" <> $SessionUUID]]}},
					{False, {ObjectP[Object[Software, ManifoldKernelCommand, "Test ManifoldKernelCommand Job 3 for updateParallelComputationFields tests" <> $SessionUUID]], ObjectP[Object[Notebook, Job, "Test Job 3 for updateParallelComputationFields tests" <> $SessionUUID]]}},
					{False, {ObjectP[Object[Software, ManifoldKernelCommand, "Test ManifoldKernelCommand Job 6 for updateParallelComputationFields tests" <> $SessionUUID]], ObjectP[Object[Notebook, Job, "Test Job 6 for updateParallelComputationFields tests" <> $SessionUUID]]}}
				},
				{TimedOut, TimedOut},
				{ObjectP[Object[Protocol, NMR, "Test protocol 4 for updateParallelComputationFields tests" <> $SessionUUID]]},
				{
					ObjectP[Object[Software, ManifoldKernel, "Test ManifoldKernel 1 for updateParallelComputationFields tests" <> $SessionUUID]],
					ObjectP[Object[Software, ManifoldKernel, "Test ManifoldKernel 2 for updateParallelComputationFields tests" <> $SessionUUID]],
					ObjectP[Object[Software, ManifoldKernel, "Test ManifoldKernel 2 for updateParallelComputationFields tests" <> $SessionUUID]]
				}
			}
		]
	},
	Stubs :> {
		CreateAsanaTask[x_]:=x,
		$DeveloperSearch = True,
		$RequiredSearchName = $SessionUUID,
		AbortManifoldKernel[__]:=Null,
		LaunchManifoldKernel[__]:=Null,
		Manifold`Private`kernelForConfiguration[__]:=Object[Software, ManifoldKernel, "Test ManifoldKernel 3 for updateParallelComputationFields tests" <> $SessionUUID]
	},
	SymbolSetUp :> (
		Module[{objs, existingObjs},
			objs = {
				Object[Protocol, HPLC, "Test protocol 1 for updateParallelComputationFields tests" <> $SessionUUID],
				Object[Protocol, Filter, "Test protocol 2 for updateParallelComputationFields tests" <> $SessionUUID],
				Object[Protocol, Transfer, "Test protocol 3 for updateParallelComputationFields tests" <> $SessionUUID],
				Object[Protocol, NMR, "Test protocol 4 for updateParallelComputationFields tests" <> $SessionUUID],
				Object[Software, ManifoldKernelCommand, "Test ManifoldKernelCommand Job 1 for updateParallelComputationFields tests" <> $SessionUUID],
				Object[Software, ManifoldKernelCommand, "Test ManifoldKernelCommand Job 2 for updateParallelComputationFields tests" <> $SessionUUID],
				Object[Software, ManifoldKernelCommand, "Test ManifoldKernelCommand Job 3 for updateParallelComputationFields tests" <> $SessionUUID],
				Object[Software, ManifoldKernelCommand, "Test ManifoldKernelCommand Job 4 for updateParallelComputationFields tests" <> $SessionUUID],
				Object[Software, ManifoldKernelCommand, "Test ManifoldKernelCommand Job 5 for updateParallelComputationFields tests" <> $SessionUUID],
				Object[Software, ManifoldKernelCommand, "Test ManifoldKernelCommand Job 6 for updateParallelComputationFields tests" <> $SessionUUID],
				Object[Software, ManifoldKernelCommand, "Test ManifoldKernelCommand Job 7 for updateParallelComputationFields tests" <> $SessionUUID],
				Object[Software, ManifoldKernelCommand, "Test ManifoldKernelCommand Job 8 for updateParallelComputationFields tests" <> $SessionUUID],
				Object[Software, ManifoldKernelCommand, "Test ManifoldKernelCommand Job 9 for updateParallelComputationFields tests" <> $SessionUUID],
				Object[Notebook, Job, "Test Job 1 for updateParallelComputationFields tests" <> $SessionUUID],
				Object[Notebook, Job, "Test Job 2 for updateParallelComputationFields tests" <> $SessionUUID],
				Object[Notebook, Job, "Test Job 3 for updateParallelComputationFields tests" <> $SessionUUID],
				Object[Notebook, Job, "Test Job 4 for updateParallelComputationFields tests" <> $SessionUUID],
				Object[Notebook, Job, "Test Job 5 for updateParallelComputationFields tests" <> $SessionUUID],
				Object[Notebook, Job, "Test Job 6 for updateParallelComputationFields tests" <> $SessionUUID],
				Object[Notebook, Job, "Test Job 7 for updateParallelComputationFields tests" <> $SessionUUID],
				Object[Notebook, Job, "Test Job 8 for updateParallelComputationFields tests" <> $SessionUUID],
				Object[Software, ManifoldKernel, "Test ManifoldKernel 1 for updateParallelComputationFields tests" <> $SessionUUID],
				Object[Software, ManifoldKernel, "Test ManifoldKernel 2 for updateParallelComputationFields tests" <> $SessionUUID],
				Object[Software, ManifoldKernel, "Test ManifoldKernel 3 for updateParallelComputationFields tests" <> $SessionUUID],
				Object[Notebook, Computation, "Test Computation 1 for updateParallelComputationFields tests" <> $SessionUUID],
				Object[Notebook, Computation, "Test Computation 2 for updateParallelComputationFields tests" <> $SessionUUID],
				Object[Notebook, Computation, "Test Computation 3 for updateParallelComputationFields tests" <> $SessionUUID],
				Object[Notebook, Computation, "Test Computation 4 for updateParallelComputationFields tests" <> $SessionUUID],
				Object[Notebook, Computation, "Test Computation 5 for updateParallelComputationFields tests" <> $SessionUUID],
				Object[Notebook, Computation, "Test Computation 6 for updateParallelComputationFields tests" <> $SessionUUID],
				Object[Notebook, Computation, "Test Computation 7 for updateParallelComputationFields tests" <> $SessionUUID],
				Object[Notebook, Computation, "Test Computation 8 for updateParallelComputationFields tests" <> $SessionUUID]
			};
			existingObjs = PickList[objs, DatabaseMemberQ[objs]];
			EraseObject[existingObjs, Force -> True, Verbose -> False]
		];
		Module[{testProt1, testProt2, testProt3, testProt4, manifoldKernelCommand1, manifoldKernelCommand2, manifoldKernelCommand3,
			manifoldKernelCommand4, manifoldKernelCommand5, manifoldKernelCommand6, manifoldKernelCommand7, manifoldKernelCommand8, manifoldKernelCommand9,
			job1, job2, job3, job4, job5, job6, job7, job8, comp1, comp2, comp3, comp4, comp5, comp6, comp7, comp8, kernel1, kernel2, kernel3},

			{
				(*1*)testProt1,
				(*2*)testProt2,
				(*3*)testProt3,
				(*4*)testProt4,
				(*5*)manifoldKernelCommand1,
				(*6*)manifoldKernelCommand2,
				(*7*)manifoldKernelCommand3,
				(*8*)manifoldKernelCommand4,
				(*9*)manifoldKernelCommand5,
				(*10*)manifoldKernelCommand6,
				(*11*)manifoldKernelCommand7,
				(*12*)manifoldKernelCommand8,
				(*13*)manifoldKernelCommand9,
				(*14*)job1,
				(*15*)job2,
				(*16*)job3,
				(*17*)job4,
				(*18*)job5,
				(*19*)job6,
				(*20*)job7,
				(*21*)job8,
				(*22*)comp1,
				(*23*)comp2,
				(*24*)comp3,
				(*25*)comp4,
				(*26*)comp5,
				(*27*)comp6,
				(*28*)comp7,
				(*29*)comp8,
				(*30*)kernel1,
				(*31*)kernel2,
				(*32*)kernel3
			} = CreateID[{
				(*1*)Object[Protocol, HPLC],
				(*2*)Object[Protocol, Filter],
				(*3*)Object[Protocol, Transfer],
				(*4*)Object[Protocol, NMR],
				(*5*)Object[Software, ManifoldKernelCommand],
				(*6*)Object[Software, ManifoldKernelCommand],
				(*7*)Object[Software, ManifoldKernelCommand],
				(*8*)Object[Software, ManifoldKernelCommand],
				(*9*)Object[Software, ManifoldKernelCommand],
				(*10*)Object[Software, ManifoldKernelCommand],
				(*11*)Object[Software, ManifoldKernelCommand],
				(*12*)Object[Software, ManifoldKernelCommand],
				(*13*)Object[Software, ManifoldKernelCommand],
				(*14*)Object[Notebook, Job],
				(*15*)Object[Notebook, Job],
				(*16*)Object[Notebook, Job],
				(*17*)Object[Notebook, Job],
				(*18*)Object[Notebook, Job],
				(*19*)Object[Notebook, Job],
				(*20*)Object[Notebook, Job],
				(*21*)Object[Notebook, Job],
				(*22*)Object[Notebook, Computation],
				(*23*)Object[Notebook, Computation],
				(*24*)Object[Notebook, Computation],
				(*25*)Object[Notebook, Computation],
				(*26*)Object[Notebook, Computation],
				(*27*)Object[Notebook, Computation],
				(*28*)Object[Notebook, Computation],
				(*29*)Object[Notebook, Computation],
				(*30*)Object[Software, ManifoldKernel],
				(*31*)Object[Software, ManifoldKernel],
				(*32*)Object[Software, ManifoldKernel]
			}];

			Upload[{
				<|
					Object -> testProt1,
					DeveloperObject -> True,
					Name -> "Test protocol 1 for updateParallelComputationFields tests" <> $SessionUUID,
					Author -> Link[$PersonID, ProtocolsAuthored],
					ComputationsOutstanding -> True,
					Replace[ParallelComputations] -> Link[{manifoldKernelCommand1, manifoldKernelCommand2, job1, job2}],
					Replace[ErroneousComputations] -> {Link[manifoldKernelCommand2]},
					RootProtocol -> Link[testProt1]
				|>,
				<|
					Object -> testProt2,
					DeveloperObject -> True,
					Name -> "Test protocol 2 for updateParallelComputationFields tests" <> $SessionUUID,
					Author -> Link[$PersonID, ProtocolsAuthored],
					ComputationsOutstanding -> True,
					Replace[ParallelComputations] -> Link[{manifoldKernelCommand3, manifoldKernelCommand4, job3, job4}],
					RootProtocol -> Link[testProt2]
				|>,
				<|
					Object -> testProt3,
					DeveloperObject -> True,
					Name -> "Test protocol 3 for updateParallelComputationFields tests" <> $SessionUUID,
					Author -> Link[$PersonID, ProtocolsAuthored],
					ComputationsOutstanding -> True,
					Replace[ParallelComputations] -> Link[{manifoldKernelCommand5, manifoldKernelCommand6, job5, job6}],
					RootProtocol -> Link[testProt3]
				|>,
				<|
					Object -> testProt4,
					DeveloperObject -> True,
					Name -> "Test protocol 4 for updateParallelComputationFields tests" <> $SessionUUID,
					Author -> Link[$PersonID, ProtocolsAuthored],
					ComputationsOutstanding -> True,
					Replace[ParallelComputations] -> Link[{manifoldKernelCommand7, manifoldKernelCommand8, manifoldKernelCommand9}],
					RootProtocol -> Link[testProt4]
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
					Object -> manifoldKernelCommand7,
					DeveloperObject -> True,
					Name -> "Test ManifoldKernelCommand Job 7 for updateParallelComputationFields tests" <> $SessionUUID,
					Command -> "1 + 3",
					Result -> "4",
					Replace[Messages] -> {},
					Status -> Completed,
					DateCreated -> Now - 1 Hour,
					DateStarted -> Now - 0.2 Hour,
					ManifoldKernel -> Link[kernel1, Commands]
				|>,
				<|
					Object -> manifoldKernelCommand8,
					DeveloperObject -> True,
					Name -> "Test ManifoldKernelCommand Job 8 for updateParallelComputationFields tests" <> $SessionUUID,
					Command -> "1 + 3",
					Replace[Messages] -> {},
					Status -> Pending,
					DateCreated -> Now - 1 Hour,
					ManifoldKernel -> Link[kernel2, Commands]
				|>,
				<|
					Object -> manifoldKernelCommand9,
					DeveloperObject -> True,
					Name -> "Test ManifoldKernelCommand Job 9 for updateParallelComputationFields tests" <> $SessionUUID,
					Command -> "1 + 3",
					Replace[Messages] -> {},
					Status -> Pending,
					DateCreated -> Now - 1 Hour,
					ManifoldKernel -> Link[kernel2, Commands]
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
				|>,
				<|
					Object -> kernel1,
					DeveloperObject -> True,
					Name -> "Test ManifoldKernel 1 for updateParallelComputationFields tests" <> $SessionUUID,
					Notebook -> Link[Object[LaboratoryNotebook, "Parallel Execute Notebook"], Objects],
					ManifoldJob -> Link[job7],
					Available -> False
				|>,
				<|
					Object -> kernel2,
					DeveloperObject -> True,
					Name -> "Test ManifoldKernel 2 for updateParallelComputationFields tests" <> $SessionUUID,
					Notebook -> Link[Object[LaboratoryNotebook, "Parallel Execute Notebook"], Objects],
					ManifoldJob -> Link[job8]
				|>,
				<|
					Object -> kernel3,
					DeveloperObject -> True,
					Name -> "Test ManifoldKernel 3 for updateParallelComputationFields tests" <> $SessionUUID,
					Notebook -> Link[Object[LaboratoryNotebook, "Parallel Execute Notebook"], Objects]
				|>,
				<|
					Object -> job7,
					DeveloperObject -> True,
					Name -> "Test Job 7 for updateParallelComputationFields tests" <> $SessionUUID,
					Status -> Inactive,
					SLLVersion -> "stable",
					SLLCommit -> "abcde",
					HardwareConfiguration -> Standard,
					MathematicaVersion -> "13.3.1",
					RunAsUser -> Link[Object[User, Emerald, Developer, "steven"]]
				|>,
				<|
					Object -> job8,
					DeveloperObject -> True,
					Name -> "Test Job 8 for updateParallelComputationFields tests" <> $SessionUUID,
					Status -> Inactive,
					SLLVersion -> "stable",
					SLLCommit -> "abcde",
					HardwareConfiguration -> Standard,
					MathematicaVersion -> "13.3.1",
					RunAsUser -> Link[Object[User, Emerald, Developer, "steven"]]
				|>,
				<|
					Object -> comp7,
					DeveloperObject -> True,
					Name -> "Test Computation 7 for updateParallelComputationFields tests" <> $SessionUUID,
					Status -> Completed,
					ErrorMessage -> Null,
					Job -> Link[job7, Computations]
				|>,
				<|
					Object -> comp8,
					DeveloperObject -> True,
					Name -> "Test Computation 8 for updateParallelComputationFields tests" <> $SessionUUID,
					Status -> Error,
					ErrorMessage -> "Computation failed to stage within 15 minutes of being ready. This typically indicates that the Manifold rate limit has been exceeded, which occurs when a large number of jobs are submitted simultaneously. Please verify you are not creating more jobs than intended, then contact the Platform team for help with this error.",
					Job -> Link[job8, Computations]
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
				Object[Protocol, NMR, "Test protocol 4 for updateParallelComputationFields tests" <> $SessionUUID],
				Object[Software, ManifoldKernelCommand, "Test ManifoldKernelCommand Job 1 for updateParallelComputationFields tests" <> $SessionUUID],
				Object[Software, ManifoldKernelCommand, "Test ManifoldKernelCommand Job 2 for updateParallelComputationFields tests" <> $SessionUUID],
				Object[Software, ManifoldKernelCommand, "Test ManifoldKernelCommand Job 3 for updateParallelComputationFields tests" <> $SessionUUID],
				Object[Software, ManifoldKernelCommand, "Test ManifoldKernelCommand Job 4 for updateParallelComputationFields tests" <> $SessionUUID],
				Object[Software, ManifoldKernelCommand, "Test ManifoldKernelCommand Job 5 for updateParallelComputationFields tests" <> $SessionUUID],
				Object[Software, ManifoldKernelCommand, "Test ManifoldKernelCommand Job 6 for updateParallelComputationFields tests" <> $SessionUUID],
				Object[Software, ManifoldKernelCommand, "Test ManifoldKernelCommand Job 7 for updateParallelComputationFields tests" <> $SessionUUID],
				Object[Software, ManifoldKernelCommand, "Test ManifoldKernelCommand Job 8 for updateParallelComputationFields tests" <> $SessionUUID],
				Object[Software, ManifoldKernelCommand, "Test ManifoldKernelCommand Job 9 for updateParallelComputationFields tests" <> $SessionUUID],
				Object[Notebook, Job, "Test Job 1 for updateParallelComputationFields tests" <> $SessionUUID],
				Object[Notebook, Job, "Test Job 2 for updateParallelComputationFields tests" <> $SessionUUID],
				Object[Notebook, Job, "Test Job 3 for updateParallelComputationFields tests" <> $SessionUUID],
				Object[Notebook, Job, "Test Job 4 for updateParallelComputationFields tests" <> $SessionUUID],
				Object[Notebook, Job, "Test Job 5 for updateParallelComputationFields tests" <> $SessionUUID],
				Object[Notebook, Job, "Test Job 6 for updateParallelComputationFields tests" <> $SessionUUID],
				Object[Notebook, Job, "Test Job 7 for updateParallelComputationFields tests" <> $SessionUUID],
				Object[Notebook, Job, "Test Job 8 for updateParallelComputationFields tests" <> $SessionUUID],
				Object[Software, ManifoldKernel, "Test ManifoldKernel 1 for updateParallelComputationFields tests" <> $SessionUUID],
				Object[Software, ManifoldKernel, "Test ManifoldKernel 2 for updateParallelComputationFields tests" <> $SessionUUID],
				Object[Software, ManifoldKernel, "Test ManifoldKernel 3 for updateParallelComputationFields tests" <> $SessionUUID],
				Object[Notebook, Computation, "Test Computation 1 for updateParallelComputationFields tests" <> $SessionUUID],
				Object[Notebook, Computation, "Test Computation 2 for updateParallelComputationFields tests" <> $SessionUUID],
				Object[Notebook, Computation, "Test Computation 3 for updateParallelComputationFields tests" <> $SessionUUID],
				Object[Notebook, Computation, "Test Computation 4 for updateParallelComputationFields tests" <> $SessionUUID],
				Object[Notebook, Computation, "Test Computation 5 for updateParallelComputationFields tests" <> $SessionUUID],
				Object[Notebook, Computation, "Test Computation 6 for updateParallelComputationFields tests" <> $SessionUUID],
				Object[Notebook, Computation, "Test Computation 7 for updateParallelComputationFields tests" <> $SessionUUID],
				Object[Notebook, Computation, "Test Computation 8 for updateParallelComputationFields tests" <> $SessionUUID]
			};
			existingObjs = PickList[objs, DatabaseMemberQ[objs]];
			EraseObject[existingObjs, Force -> True, Verbose -> False]
		]
	)
];