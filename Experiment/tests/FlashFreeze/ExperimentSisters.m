(* ::Subsection:: *)
(*ExperimentFlashFreezePreview*)


DefineTests[
	ExperimentFlashFreezePreview,
	{
		Example[{Basic,"No preview is currently available for ExperimentFlashFreeze:"},
			ExperimentFlashFreezePreview[{Object[Sample,"FlashFreezePreview Test Water Sample1 " <> $SessionUUID],Object[Sample,"FlashFreezePreview Test Water Sample2 " <> $SessionUUID]}],
			Null
		],
		Example[{Additional,"If you wish to understand how the experiment will be performed try using ExperimentFlashFreezeOptions:"},
			ExperimentFlashFreezeOptions[{Object[Sample,"FlashFreezePreview Test Water Sample3 " <> $SessionUUID],Object[Sample,"FlashFreezePreview Test Water Sample1 " <> $SessionUUID]}],
			_Grid
		],
		Example[{Additional,"The inputs and options can also be checked to verify that the experiment can be safely run by using ValidExperimentFlashFreezeQ:"},
			ValidExperimentFlashFreezeQ[{Object[Sample,"FlashFreezePreview Test Water Sample1 " <> $SessionUUID],Object[Sample,"FlashFreezePreview Test Water Sample2 " <> $SessionUUID]},Verbose->Failures],
			True
		]
	},
	Stubs:>{
		(* I am an important stub that prevents the tester from getting a bunch of notifications *)
		$PersonID=Object[User,"Test user for notebook-less test protocols"]
	},
	SymbolSetUp:>(
		(* Turn off warnings related to the state of the lab - is okay if we're using a model with no current instances *)
		Off[Warning::SamplesOutOfStock];
		Off[Warning::InstrumentUndergoingMaintenance];

		$CreatedObjects = {};

		(* IMPORTANT: Make sure that any objects you upload have DeveloperObject->True. *)
		(* Erase any objects that we failed to erase in the last unit test. *)
		Module[{namedObjects},
			namedObjects = {
				Object[Container, Vessel, "FlashFreezePreview Test Tube 1 " <> $SessionUUID],
				Object[Container, Vessel, "FlashFreezePreview Test Tube 2 " <> $SessionUUID],
				Object[Container, Vessel, "FlashFreezePreview Test Tube 3 " <> $SessionUUID],
				Object[Sample, "FlashFreezePreview Test Water Sample1 " <> $SessionUUID],
				Object[Sample, "FlashFreezePreview Test Water Sample2 " <> $SessionUUID],
				Object[Sample, "FlashFreezePreview Test Water Sample3 " <> $SessionUUID]
			};

			EraseObject[
				PickList[namedObjects, DatabaseMemberQ[namedObjects]],
				Force->True,
				Verbose->False
			]
		];

		Module[{testtube1, testtube2, testtube3, waterSample1, waterSample2, waterSample3},
			(* Create some containers *)
			{
				testtube1,
				testtube2,
				testtube3
			} = Upload[{
				<|Type->Object[Container, Vessel], Model->Link[Model[Container, Vessel, "2mL Tube"], Objects], Name->"FlashFreezePreview Test Tube 1 " <> $SessionUUID, Site -> Link[$Site], DeveloperObject->True|>,
				<|Type->Object[Container, Vessel], Model->Link[Model[Container, Vessel, "2mL Tube"], Objects], Name->"FlashFreezePreview Test Tube 2 " <> $SessionUUID, Site -> Link[$Site], DeveloperObject->True|>,
				<|Type->Object[Container, Vessel], Model->Link[Model[Container, Vessel, "2mL Tube"], Objects], Name->"FlashFreezePreview Test Tube 3 " <> $SessionUUID, Site -> Link[$Site], DeveloperObject->True|>
			}];

			(* Create some samples *)
			{
				waterSample1,
				waterSample2,
				waterSample3
			} = UploadSample[
				{
					Model[Sample, "Milli-Q water"],
					Model[Sample, "Milli-Q water"],
					Model[Sample, "Milli-Q water"]
				},
				{
					{"A1", testtube1},
					{"A1", testtube2},
					{"A1", testtube3}
				},
				InitialAmount->{
					100 Microliter,
					1.1 Milliliter,
					200 Microliter
				},
				StorageCondition->AmbientStorage
			];

			(* Secondary uploads *)
			Upload[{
				<|Object->waterSample1, Name->"FlashFreezePreview Test Water Sample1 " <> $SessionUUID, Status->Available, DeveloperObject->True, ExpirationDate->Now + 5 Year|>,
				<|Object->waterSample2, Name->"FlashFreezePreview Test Water Sample2 " <> $SessionUUID, Status->Available, DeveloperObject->True, ExpirationDate->Now + 5 Year|>,
				<|Object->waterSample3, Name->"FlashFreezePreview Test Water Sample3 " <> $SessionUUID, Status->Available, DeveloperObject->True, ExpirationDate->Now + 5 Year|>
			}];
		]
	),
	Stubs:>{$PersonID=Object[User,"Test user for notebook-less test protocols"]},

	SymbolTearDown:>(
		On[Warning::SamplesOutOfStock];
		On[Warning::InstrumentUndergoingMaintenance];

		(* Erase all objects that were created in the course of these tests *)
		EraseObject[
			PickList[    $CreatedObjects,
				DatabaseMemberQ[$CreatedObjects]
			],
			Force->True,
			Verbose->False
		];
		(* Cleanse $CreatedObjects *)
		Unset[$CreatedObjects];
	)
];




(* ::Subsection:: *)
(*ExperimentFlashFreezeOptions*)


DefineTests[
	ExperimentFlashFreezeOptions,
	{
		Example[{Basic,"Display the option values which will be used in the experiment:"},
			ExperimentFlashFreezeOptions[{Object[Sample,"FlashFreezeOptions Test Water Sample1 " <> $SessionUUID],Object[Sample,"FlashFreezeOptions Test Water Sample2 " <> $SessionUUID]}],
			_Grid
		],
		Example[{Basic,"Any potential issues with provided inputs/options will be displayed:"},
			ExperimentFlashFreezeOptions[{Object[Sample,"FlashFreezeOptions Test Water Sample3 " <> $SessionUUID]},MaxFreezingTime->5 Hour,FreezeUntilFrozen->False],
			_Grid,
			Messages:>{Error::InvalidOption,Error::MaxFreezeUntilFrozen}
		],
		Example[
			{Options,OutputFormat,"If OutputFormat -> List, return a list of options:"},
			ExperimentFlashFreezeOptions[{Object[Sample,"FlashFreezeOptions Test Water Sample1 " <> $SessionUUID]},OutputFormat->List],
			{(_Rule|_RuleDelayed)..}
		]
	},
	Stubs:>{
		(* I am an important stub that prevents the tester from getting a bunch of notifications *)
		$PersonID=Object[User,"Test user for notebook-less test protocols"]
	},
	SymbolSetUp:> (
		(* Turn off warnings related to the state of the lab - is okay if we're using a model with no current instances *)
		Off[Warning::SamplesOutOfStock];
		Off[Warning::InstrumentUndergoingMaintenance];

		$CreatedObjects = {};

		(* IMPORTANT: Make sure that any objects you upload have DeveloperObject->True. *)
		(* Erase any objects that we failed to erase in the last unit test. *)
		Module[{namedObjects},
			namedObjects = {
				Object[Container, Vessel, "FlashFreezeOptions Test Tube 1 " <> $SessionUUID],
				Object[Container, Vessel, "FlashFreezeOptions Test Tube 2 " <> $SessionUUID],
				Object[Container, Vessel, "FlashFreezeOptions Test Tube 3 " <> $SessionUUID],
				Object[Sample, "FlashFreezeOptions Test Water Sample1 " <> $SessionUUID],
				Object[Sample, "FlashFreezeOptions Test Water Sample2 " <> $SessionUUID],
				Object[Sample, "FlashFreezeOptions Test Water Sample3 " <> $SessionUUID]
			};

			EraseObject[
				PickList[namedObjects, DatabaseMemberQ[namedObjects]],
				Force->True,
				Verbose->False
			]
		];

		Module[{testtube1, testtube2, testtube3, waterSample1, waterSample2, waterSample3},
			(* Create some containers *)
			{
				testtube1,
				testtube2,
				testtube3
			} = Upload[{
				<|Type->Object[Container, Vessel], Model->Link[Model[Container, Vessel, "2mL Tube"], Objects], Name->"FlashFreezeOptions Test Tube 1 " <> $SessionUUID, Site -> Link[$Site], DeveloperObject->True|>,
				<|Type->Object[Container, Vessel], Model->Link[Model[Container, Vessel, "2mL Tube"], Objects], Name->"FlashFreezeOptions Test Tube 2 " <> $SessionUUID, Site -> Link[$Site], DeveloperObject->True|>,
				<|Type->Object[Container, Vessel], Model->Link[Model[Container, Vessel, "2mL Tube"], Objects], Name->"FlashFreezeOptions Test Tube 3 " <> $SessionUUID, Site -> Link[$Site], DeveloperObject->True|>
			}];

			(* Create some samples *)
			{
				waterSample1,
				waterSample2,
				waterSample3
			} = UploadSample[
				{
					Model[Sample, "Milli-Q water"],
					Model[Sample, "Milli-Q water"],
					Model[Sample, "Milli-Q water"]
				},
				{
					{"A1", testtube1},
					{"A1", testtube2},
					{"A1", testtube3}
				},
				InitialAmount->{
					100 Microliter,
					1.1 Milliliter,
					200 Microliter
				},
				StorageCondition->AmbientStorage
			];

			(* Secondary uploads *)
			Upload[{
				<|Object->waterSample1, Name->"FlashFreezeOptions Test Water Sample1 " <> $SessionUUID, Status->Available, DeveloperObject->True, ExpirationDate->Now + 5 Year|>,
				<|Object->waterSample2, Name->"FlashFreezeOptions Test Water Sample2 " <> $SessionUUID, Status->Available, DeveloperObject->True, ExpirationDate->Now + 5 Year|>,
				<|Object->waterSample3, Name->"FlashFreezeOptions Test Water Sample3 " <> $SessionUUID, Status->Available, DeveloperObject->True, ExpirationDate->Now + 5 Year|>
			}];
		]
	),

	SymbolTearDown:>(
		On[Warning::SamplesOutOfStock];
		On[Warning::InstrumentUndergoingMaintenance];

		(* Erase all objects that were created in the course of these tests *)
		EraseObject[
			PickList[    $CreatedObjects,
				DatabaseMemberQ[$CreatedObjects]
			],
			Force->True,
			Verbose->False
		];
		(* Cleanse $CreatedObjects *)
		Unset[$CreatedObjects];
	)
];


(* ::Subsection:: *)
(*ValidExperimentFlashFreezeQ*)


DefineTests[
	ValidExperimentFlashFreezeQ,
	{
		Example[{Basic,"Verify that the experiment can be run without issue:"},
			ValidExperimentFlashFreezeQ[{Object[Sample,"FlashFreezeValid Test Water Sample1 " <> $SessionUUID],Object[Sample,"FlashFreezeValid Test Water Sample3 " <> $SessionUUID]}],
			True
		],
		Example[{Basic,"Return False if there are problems with the inputs or options:"},
			ValidExperimentFlashFreezeQ[Object[Sample,"FlashFreezeValid Test Water Sample2 " <> $SessionUUID],MaxFreezingTime->5 Hour,FreezeUntilFrozen->False],
			False
		],
		Example[{Options,OutputFormat,"Return a test summary:"},
			ValidExperimentFlashFreezeQ[Object[Sample,"FlashFreezeValid Test Water Sample1 " <> $SessionUUID],OutputFormat->TestSummary],
			_EmeraldTestSummary
		],
		Example[{Options,Verbose,"Print verbose messages reporting test passage/failure:"},
			ValidExperimentFlashFreezeQ[Object[Sample,"FlashFreezeValid Test Water Sample1 " <> $SessionUUID],Verbose->True],
			True
		]
	},
	Stubs:>{
		(* I am an important stub that prevents the tester from getting a bunch of notifications *)
		$PersonID=Object[User,"Test user for notebook-less test protocols"],

		(* ValidObjectQ is super slow so just doing this here *)
		ValidObjectQ[objs_,OutputFormat->Boolean]:=ConstantArray[True,Length[objs]]
	},
	SymbolSetUp:>(
		(* Turn off warnings related to the state of the lab - is okay if we're using a model with no current instances *)
		Off[Warning::SamplesOutOfStock];
		Off[Warning::InstrumentUndergoingMaintenance];

		$CreatedObjects = {};

		(* IMPORTANT: Make sure that any objects you upload have DeveloperObject->True. *)
		(* Erase any objects that we failed to erase in the last unit test. *)
		Module[{namedObjects},
			namedObjects = {
				Object[Container, Vessel, "FlashFreezeValid Test Tube 1 " <> $SessionUUID],
				Object[Container, Vessel, "FlashFreezeValid Test Tube 2 " <> $SessionUUID],
				Object[Container, Vessel, "FlashFreezeValid Test Tube 3 " <> $SessionUUID],
				Object[Sample, "FlashFreezeValid Test Water Sample1 " <> $SessionUUID],
				Object[Sample, "FlashFreezeValid Test Water Sample2 " <> $SessionUUID],
				Object[Sample, "FlashFreezeValid Test Water Sample3 " <> $SessionUUID]
			};

			EraseObject[
				PickList[namedObjects, DatabaseMemberQ[namedObjects]],
				Force->True,
				Verbose->False
			]
		];

		Module[{testtube1, testtube2, testtube3, waterSample1, waterSample2, waterSample3},
			(* Create some containers *)
			{
				testtube1,
				testtube2,
				testtube3
			} = Upload[{
				<|Type->Object[Container, Vessel], Model->Link[Model[Container, Vessel, "2mL Tube"], Objects], Name->"FlashFreezeValid Test Tube 1 " <> $SessionUUID, Site -> Link[$Site], DeveloperObject->True|>,
				<|Type->Object[Container, Vessel], Model->Link[Model[Container, Vessel, "2mL Tube"], Objects], Name->"FlashFreezeValid Test Tube 2 " <> $SessionUUID, Site -> Link[$Site], DeveloperObject->True|>,
				<|Type->Object[Container, Vessel], Model->Link[Model[Container, Vessel, "2mL Tube"], Objects], Name->"FlashFreezeValid Test Tube 3 " <> $SessionUUID, Site -> Link[$Site], DeveloperObject->True|>
			}];

			(* Create some samples *)
			{
				waterSample1,
				waterSample2,
				waterSample3
			} = UploadSample[
				{
					Model[Sample, "Milli-Q water"],
					Model[Sample, "Milli-Q water"],
					Model[Sample, "Milli-Q water"]
				},
				{
					{"A1", testtube1},
					{"A1", testtube2},
					{"A1", testtube3}
				},
				InitialAmount->{
					100 Microliter,
					1.1 Milliliter,
					200 Microliter
				},
				StorageCondition->AmbientStorage
			];

			(* Secondary uploads *)
			Upload[{
				<|Object->waterSample1, Name->"FlashFreezeValid Test Water Sample1 " <> $SessionUUID, Status->Available, DeveloperObject->True, ExpirationDate->Now + 5 Year|>,
				<|Object->waterSample2, Name->"FlashFreezeValid Test Water Sample2 " <> $SessionUUID, Status->Available, DeveloperObject->True, ExpirationDate->Now + 5 Year|>,
				<|Object->waterSample3, Name->"FlashFreezeValid Test Water Sample3 " <> $SessionUUID, Status->Available, DeveloperObject->True, ExpirationDate->Now + 5 Year|>
			}];
		]
	),

	SymbolTearDown:>(
		On[Warning::SamplesOutOfStock];
		On[Warning::InstrumentUndergoingMaintenance];

		(* Erase all objects that were created in the course of these tests *)
		EraseObject[
			PickList[$CreatedObjects,
				DatabaseMemberQ[$CreatedObjects]
			],
			Force->True,
			Verbose->False
		];
		(* Cleanse $CreatedObjects *)
		Unset[$CreatedObjects];
	)
];
