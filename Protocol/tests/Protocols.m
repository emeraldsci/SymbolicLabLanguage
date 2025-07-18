(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

(* ::Subsection:: *)
(*ConfirmProtocol *)


DefineTests[
	ConfirmProtocol,
	{

		Example[{Basic,"Direct the ECL to run a protocol that is InCart as soon as possible:"},
			ConfirmProtocol[Object[Protocol, HPLC, "id:xRO9n3BVnO6w"]],
			Object[Protocol, HPLC, "id:xRO9n3BVnO6w"],
			TearDown :> (
				procedureEvents = Download[Object[Protocol, HPLC, "id:xRO9n3BVnO6w"],ProcedureLog[Object]];
				EraseObject[procedureEvents, Force -> True, Verbose -> False];

				Upload[
					Association[
						Object -> Object[Protocol, HPLC, "id:xRO9n3BVnO6w"],
						Status -> InCart,
						Replace[StatusLog] -> {}
					],
					Verbose -> False
				]
			),
			Variables:>{procedureEvents}
		],

		Example[{Basic,"Indicate that multiple protocols should be run:"},
			ConfirmProtocol[{Object[Protocol, HPLC, "id:xRO9n3BVnO6w"],Object[Protocol, ManualSamplePreparation, "test msp 1 InCart for ConfirmProtocol unit tests "<>$SessionUUID]}],
			{Object[Protocol, HPLC, "id:xRO9n3BVnO6w"],ObjectP[Object[Protocol, ManualSamplePreparation, "test msp 1 InCart for ConfirmProtocol unit tests "<>$SessionUUID]]},
			TearDown :> (
				procedureEvents = Flatten[Download[{Object[Protocol, HPLC, "id:xRO9n3BVnO6w"],Object[Protocol, ManualSamplePreparation, "test msp 1 InCart for ConfirmProtocol unit tests "<>$SessionUUID]},ProcedureLog[Object]]];
				EraseObject[procedureEvents, Force -> True, Verbose -> False];

				Upload[
					{
						Association[
							Object -> Object[Protocol, HPLC, "id:xRO9n3BVnO6w"],
							Status -> InCart,
							Replace[StatusLog] -> {}
						],
						Association[
							Object -> Object[Protocol, ManualSamplePreparation, "test msp 1 InCart for ConfirmProtocol unit tests "<>$SessionUUID],
							Status -> InCart,
							Replace[StatusLog] -> {}
						]
					},
					Verbose -> False
				]
			),
			Variables:>{procedureEvents}
		],

		Example[{Basic,"Confirming a protocol will move it from the cart to the set of protocols to be run in the lab:"},
			(
				ConfirmProtocol[Object[Protocol, HPLC, "id:xRO9n3BVnO6w"]];
				Download[Object[Protocol, HPLC, "id:xRO9n3BVnO6w"],{Status,DateConfirmed}]
			),
			{Processing,_DateObject},
			TearDown :> (
				procedureEvents = Download[Object[Protocol, HPLC, "id:xRO9n3BVnO6w"],ProcedureLog[Object]];
				EraseObject[procedureEvents, Force -> True, Verbose -> False];

				Upload[
					Association[
						Object -> Object[Protocol, HPLC, "id:xRO9n3BVnO6w"],
						Status -> InCart,
						Replace[StatusLog] -> {}
					],
					Verbose -> False
				]
			),
			Variables:>{procedureEvents}
		],

		Example[{Messages,"ConfirmInvalid","If a protocol is not currently InCart, it cannot be confirmed:"},
			ConfirmProtocol[Object[Protocol, HPLC, "id:R8e1PjpkaYKj"]],
			$Failed,
			Messages:>{Experiment::ConfirmInvalid}
		]
	},
	SymbolSetUp :> (
		Block[{$DeveloperUpload = True, $AllowPublicObjects = True},

			(* clean up test objects in case it was not cleaned from last unit test run *)
			confirmProtocolTestCleanup[];

			Module[{msp1},
				{
					msp1
				} = CreateID[{
					Object[Protocol, ManualSamplePreparation]
				}];

				Upload[{
					<|
						Object -> msp1,
						Name -> "test msp 1 InCart for ConfirmProtocol unit tests "<>$SessionUUID,
						DateEnqueued -> (Now - 5 Minute),
						Status -> InCart,
						OperationStatus -> None
					|>
				}]
			]

		]
	),
	SymbolTearDown :> (
		(* Erase all Notification objects that were created in the course of these tests *)
		EraseObject[
			Search[Object[Notification], Recipients == (Object[User, "Test user for notebook-less test protocols"] | Object[User, Emerald, Developer, "hendrik"] | Object[User, Emerald, Developer, "service+lab-infrastructure"])],
			Force -> True
		];
		confirmProtocolTestCleanup[];
	)
];

confirmProtocolTestCleanup[] := Module[{objects, objectsExistQ},
	(* List all test objects to erase. Can use SetUpTestObjects[]+ObjectToString[] to get the comprehensive list. *)
	objects = {
		Object[Protocol, ManualSamplePreparation, "test msp 1 InCart for ConfirmProtocol unit tests "<>$SessionUUID]
	};

	(* Check whether the names we want to give below already exist in the database *)
	objectsExistQ = DatabaseMemberQ[objects];

	(* Erase any objects that we failed to erase in the last unit test. *)
	Quiet[EraseObject[PickList[objects, objectsExistQ], Force -> True, Verbose -> False]]
];


(* ::Subsection:: *)
(*CancelProtocol *)


DefineTests[
	CancelProtocol,
	{

		Example[{Basic,"Cancel a protocol that is InCart:"},
			CancelProtocol[Object[Protocol, HPLC, "id:Y0lXejM6elRW"]],
			Object[Protocol, HPLC, "id:Y0lXejM6elRW"],
			TearDown :> (
				procedureEvents = Download[Object[Protocol, HPLC, "id:Y0lXejM6elRW"],ProcedureLog[Object]];
				EraseObject[procedureEvents, Force -> True, Verbose -> False];

				Upload[
					Association[
						Object -> Object[Protocol, HPLC, "id:Y0lXejM6elRW"],
						Status -> InCart,
						Replace[StatusLog] -> {}
					],
					Verbose -> False
				]
			),
			Variables:>{procedureEvents}
		],

		Example[{Basic,"Cancel multiple protocols:"},
			CancelProtocol[{Object[Protocol, HPLC, "id:Y0lXejM6elRW"],Object[Protocol, ManualSamplePreparation, "test msp 1 Backlogged for CancelProtocol unit tests "<>$SessionUUID]}],
			{Object[Protocol, HPLC, "id:Y0lXejM6elRW"],ObjectP[Object[Protocol, ManualSamplePreparation, "test msp 1 Backlogged for CancelProtocol unit tests "<>$SessionUUID]]},
			TearDown :> (
				procedureEvents = Flatten[Download[{Object[Protocol, HPLC, "id:Y0lXejM6elRW"],Object[Protocol, ManualSamplePreparation, "test msp 1 Backlogged for CancelProtocol unit tests "<>$SessionUUID]},ProcedureLog[Object]]];
				EraseObject[procedureEvents, Force -> True, Verbose -> False];

				Upload[
					{
						Association[
							Object -> Object[Protocol, HPLC, "id:Y0lXejM6elRW"],
							Status -> InCart,
							Replace[StatusLog] -> {}
						],
						Association[
							Object -> Object[Protocol, ManualSamplePreparation, "test msp 1 Backlogged for CancelProtocol unit tests "<>$SessionUUID],
							Status -> Backlogged,
							Replace[StatusLog] -> {}
						]
					},
					Verbose -> False
				]
			),
			Variables:>{procedureEvents}
		],

		Example[{Basic,"Canceling a protocol sets its status to Canceled:"},
			(
				CancelProtocol[Object[Protocol, HPLC, "id:Y0lXejM6elRW"]];
				Download[Object[Protocol, HPLC, "id:Y0lXejM6elRW"],{Status,DateCanceled}]
			),
			{Canceled,_DateObject},
			TearDown :> (
				procedureEvents = Download[Object[Protocol, HPLC, "id:Y0lXejM6elRW"],ProcedureLog[Object]];
				EraseObject[procedureEvents, Force -> True, Verbose -> False];

				Upload[
					Association[
						Object -> Object[Protocol, HPLC, "id:Y0lXejM6elRW"],
						Status -> Backlogged,
						Replace[StatusLog] -> {}
					],
					Verbose -> False
				]
			),
			Variables:>{procedureEvents}
		],
		Example[{Basic,"Canceling a protocol that has canceled status will still have status Canceled:"},
			(
				CancelProtocol[Object[Protocol, HPLC, "id:Y0lXejM6elRW"]];
				Download[Object[Protocol, HPLC, "id:Y0lXejM6elRW"],{Status}]
			),
			{Canceled},
			TearDown :> (
				procedureEvents = Download[Object[Protocol, HPLC, "id:Y0lXejM6elRW"],ProcedureLog[Object]];
				EraseObject[procedureEvents, Force -> True, Verbose -> False];

				Upload[
					Association[
						Object -> Object[Protocol, HPLC, "id:Y0lXejM6elRW"],
						Status -> Canceled,
						Replace[StatusLog] -> {}
					],
					Verbose -> False
				]
			),
			Variables:>{procedureEvents}
		],

		Example[{Messages,"CancelInvalid","A protocol can only be canceled if it is InCart:"},
			CancelProtocol[Object[Protocol, HPLC, "id:R8e1PjpkaYKj"]],
			$Failed,
			Messages:>{Experiment::CancelInvalid}
		]
	},
	SymbolSetUp :> (
		Block[{$DeveloperUpload = True, $AllowPublicObjects = True},

			(* clean up test objects in case it was not cleaned from last unit test run *)
			cancelProtocolTestCleanup[];

			Module[{msp1},
				{
					msp1
				} = CreateID[{
					Object[Protocol, ManualSamplePreparation]
				}];

				Upload[{
					<|
						Object -> msp1,
						Name -> "test msp 1 Backlogged for CancelProtocol unit tests "<>$SessionUUID,
						DateEnqueued -> (Now - 5 Minute),
						Status -> Backlogged,
						OperationStatus -> None
					|>
				}]
			]

		]
	),
	SymbolTearDown :> (
		(* Erase all Notification objects that were created in the course of these tests *)
		EraseObject[
			Search[Object[Notification], Recipients == (Object[User, "Test user for notebook-less test protocols"] | Object[User, Emerald, Developer, "hendrik"] | Object[User, Emerald, Developer, "service+lab-infrastructure"])],
			Force -> True
		];

		cancelProtocolTestCleanup[]
	)
];

cancelProtocolTestCleanup[] := Module[{objects, objectsExistQ},
	(* List all test objects to erase. Can use SetUpTestObjects[]+ObjectToString[] to get the comprehensive list. *)
	objects = {
		Object[Protocol, ManualSamplePreparation, "test msp 1 Backlogged for CancelProtocol unit tests "<>$SessionUUID]
	};

	(* Check whether the names we want to give below already exist in the database *)
	objectsExistQ = DatabaseMemberQ[objects];

	(* Erase any objects that we failed to erase in the last unit test. *)
	Quiet[EraseObject[PickList[objects, objectsExistQ], Force -> True, Verbose -> False]]
];


(* ::Subsection:: *)
(*UnconfirmProtocol *)


DefineTests[
	UnconfirmProtocol,
	{

		Example[{Basic,"Put a protocol back into the cart:"},
			UnconfirmProtocol[Object[Protocol, HPLC, "id:Y0lXejM6elRW"]],
			Object[Protocol, HPLC, "id:Y0lXejM6elRW"],
			TearDown :> (
				procedureEvents = Download[Object[Protocol, HPLC, "id:Y0lXejM6elRW"],ProcedureLog[Object]];
				EraseObject[procedureEvents, Force -> True, Verbose -> False];

				Upload[
					Association[
						Object -> Object[Protocol, HPLC, "id:Y0lXejM6elRW"],
						Status -> InCart,
						Replace[StatusLog] -> {}
					],
					Verbose -> False
				]
			),
			Variables:>{procedureEvents}
		],

		Example[{Basic,"Unconfirm multiple protocols:"},
			UnconfirmProtocol[{Object[Protocol, HPLC, "id:Y0lXejM6elRW"],Object[Protocol, ManualSamplePreparation, "test msp 1 Backlogged for UnconfirmProtocol unit tests "<>$SessionUUID]}],
			{Object[Protocol, HPLC, "id:Y0lXejM6elRW"],ObjectP[Object[Protocol, ManualSamplePreparation, "test msp 1 Backlogged for UnconfirmProtocol unit tests "<>$SessionUUID]]},
			TearDown :> (
				procedureEvents = Flatten[Download[{Object[Protocol, HPLC, "id:Y0lXejM6elRW"],Object[Protocol, ManualSamplePreparation, "test msp 1 Backlogged for UnconfirmProtocol unit tests "<>$SessionUUID]},ProcedureLog[Object]]];
				EraseObject[procedureEvents, Force -> True, Verbose -> False];

				Upload[
					{
						Association[
							Object -> Object[Protocol, HPLC, "id:Y0lXejM6elRW"],
							Status -> InCart,
							Replace[StatusLog] -> {}
						],
						Association[
							Object -> Object[Protocol, ManualSamplePreparation, "test msp 1 Backlogged for UnconfirmProtocol unit tests "<>$SessionUUID],
							Status -> Backlogged,
							Replace[StatusLog] -> {}
						]
					},
					Verbose -> False
				]
			),
			Variables:>{procedureEvents}
		],

		Example[{Basic,"Unconfirmed protocol has a status of InCart:"},
			(
				UnconfirmProtocol[Object[Protocol, HPLC, "id:Y0lXejM6elRW"]];
				Download[Object[Protocol, HPLC, "id:Y0lXejM6elRW"],Status]
			),
			InCart,
			TearDown :> (
				procedureEvents = Download[Object[Protocol, HPLC, "id:Y0lXejM6elRW"],ProcedureLog[Object]];
				EraseObject[procedureEvents, Force -> True, Verbose -> False];

				Upload[
					Association[
						Object -> Object[Protocol, HPLC, "id:Y0lXejM6elRW"],
						Status -> Backlogged,
						Replace[StatusLog] -> {}
					],
					Verbose -> False
				]
			),
			Variables:>{procedureEvents}
		],

		Example[{Messages,"InCartInvalid","A protocol can only be put back into the cart if it has not started:"},
			UnconfirmProtocol[Object[Protocol, HPLC, "id:R8e1PjpkaYKj"]],
			$Failed,
			Messages:>{Experiment::InCartInvalid}
		]
	},
	SymbolSetUp :> (
		Block[{$DeveloperUpload = True, $AllowPublicObjects = True},

			(* clean up test objects in case it was not cleaned from last unit test run *)
			unconfirmProtocolTestCleanup[];

			Module[{msp1},
				{
					msp1
				} = CreateID[{
					Object[Protocol, ManualSamplePreparation]
				}];

				Upload[{
					<|
						Object -> msp1,
						Name -> "test msp 1 Backlogged for UnconfirmProtocol unit tests "<>$SessionUUID,
						DateEnqueued -> (Now - 5 Minute),
						Status -> Backlogged,
						OperationStatus -> None
					|>
				}]
			]

		]
	),
	SymbolTearDown :> (
		(* Erase all Notification objects that were created in the course of these tests *)
		EraseObject[
			Search[Object[Notification], Recipients == (Object[User, "Test user for notebook-less test protocols"] | Object[User, Emerald, Developer, "hendrik"] | Object[User, Emerald, Developer, "service+lab-infrastructure"])],
			Force -> True
		];

		unconfirmProtocolTestCleanup[]
	)
];

unconfirmProtocolTestCleanup[] := Module[{objects, objectsExistQ},
	(* List all test objects to erase. Can use SetUpTestObjects[]+ObjectToString[] to get the comprehensive list. *)
	objects = {
		Object[Protocol, ManualSamplePreparation, "test msp 1 Backlogged for UnconfirmProtocol unit tests "<>$SessionUUID]
	};

	(* Check whether the names we want to give below already exist in the database *)
	objectsExistQ = DatabaseMemberQ[objects];

	(* Erase any objects that we failed to erase in the last unit test. *)
	Quiet[EraseObject[PickList[objects, objectsExistQ], Force -> True, Verbose -> False]]
];

