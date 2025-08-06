(* ::Subsection:: *)
(*ExperimentEvaporatePreview*)


DefineTests[
	ExperimentEvaporatePreview,
	{
		Example[{Basic,"No preview is currently available for ExperimentEvaporate:"},
			ExperimentEvaporatePreview[{Object[Sample,"EvaporatePreview Test Water Sample"],Object[Sample,"EvaporatePreview Test Water Sample2"]}],
			Null
		],
		Example[{Additional,"If you wish to understand how the experiment will be performed try using ExperimentEvaporateOptions:"},
			ExperimentEvaporateOptions[{Object[Sample,"EvaporatePreview Test Water Sample"],Object[Sample,"EvaporatePreview Test Water Sample2"]}],
			_Grid
		],
		Example[{Additional,"The inputs and options can also be checked to verify that the experiment can be safely run by using ValidExperimentEvaporateQ:"},
			ValidExperimentEvaporateQ[{Object[Sample,"EvaporatePreview Test Water Sample"],Object[Sample,"EvaporatePreview Test Water Sample2"]},Verbose->Failures],
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
				Object[Container, Plate, "EvaporatePreview Test Plate"],
				Object[Sample, "EvaporatePreview Test Water Sample"],
				Object[Sample, "EvaporatePreview Test Water Sample2"],
				Object[Sample, "EvaporatePreview Test Water Sample3"],
				Object[Sample, "EvaporatePreview Test Water Sample4"]
			};

			EraseObject[
				PickList[namedObjects, DatabaseMemberQ[namedObjects]],
				Force->True,
				Verbose->False
			]
		];
		Module[{testPlate,waterSample,waterSample2,waterSample3,waterSample4},
			(* Create some containers *)
			testPlate=Upload[
				<|
					Type->Object[Container,Plate],
					Model->Link[Model[Container,Plate,"96-well 2mL Deep Well Plate"],Objects],
					Name->"EvaporatePreview Test Plate",
					DeveloperObject->True,
					Site->Link[$Site]
				|>
			];

			(* Create some samples *)
			{
				waterSample,
				waterSample2,
				waterSample3,
				waterSample4
			}=ECL`InternalUpload`UploadSample[
				{
					Model[Sample,"Milli-Q water"],
					Model[Sample,"Milli-Q water"],
					Model[Sample,"Milli-Q water"],
					Model[Sample,"Milli-Q water"]
				},
				{
					{"A1",testPlate},
					{"A2",testPlate},
					{"A3",testPlate},
					{"B1",testPlate}
				},
				InitialAmount->{
					10 Microliter,
					100 Microliter,
					1 Milliliter,
					1.75 Milliliter
				},
				StorageCondition->AmbientStorage
			];

			(* Secondary uploads *)
			Upload[{
				<|Object->waterSample,Name->"EvaporatePreview Test Water Sample",Status->Available,DeveloperObject->True|>,
				<|Object->waterSample2,Name->"EvaporatePreview Test Water Sample2",Status->Available,DeveloperObject->True|>,
				<|Object->waterSample3,Name->"EvaporatePreview Test Water Sample3",Status->Available,DeveloperObject->True|>,
				<|Object->waterSample4,Name->"EvaporatePreview Test Water Sample4",Status->Available,DeveloperObject->True|>
			}];
		];
	),
	Stubs :> {$PersonID = Object[User, "Test user for notebook-less test protocols"]},

	SymbolTearDown :> (
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
(*ExperimentEvaporateOptions*)


DefineTests[
	ExperimentEvaporateOptions,
	{
		Example[{Basic,"Display the option values which will be used in the experiment:"},
			ExperimentEvaporateOptions[{Object[Sample,"EvaporateOptions Test Water Sample "<>$SessionUUID]}],
			_Grid
		],
		Example[{Basic,"Any potential issues with provided inputs/options will be displayed:"},
			Quiet[ExperimentEvaporateOptions[Object[Sample,"EvaporateOptions Test Water Sample "<>$SessionUUID],
				Instrument->Object[Instrument,Evaporator,"id:kEJ9mqRxKARz"],
				FlowRateProfile -> {{1 Liter/Minute,60 Minute},{2 Liter/Minute, 45 Minute},{3 Liter/Minute, 30 Minute},{3.5 Liter/Minute, 30 Minute}}
			],Warning::InstrumentUndergoingMaintenance],
			_Grid,
			Messages:>{Error::InvalidOption,Error::FlowRateProfileLength, Warning::AliquotRequired}
		],
		Example[
			{Options,OutputFormat,"If OutputFormat -> List, return a list of options:"},
			ExperimentEvaporateOptions[{Object[Sample,"EvaporateOptions Test Water Sample "<>$SessionUUID]},OutputFormat->List],
			{(_Rule|_RuleDelayed)..}
		]
	},
	Stubs:>{
		(* I am an important stub that prevents the tester from getting a bunch of notifications *)
		$PersonID=Object[User,"Test user for notebook-less test protocols"]
	},
	SymbolSetUp:>{
		$CreatedObjects = {};

		(* IMPORTANT: Make sure that any objects you upload have DeveloperObject->True. *)
		(* Erase any objects that we failed to erase in the last unit test. *)
		Module[{namedObjects},
			namedObjects={
				Object[Container,Plate,"EvaporateOptions Test Plate "<>$SessionUUID],
				Object[Sample,"EvaporateOptions Test Water Sample "<>$SessionUUID],
				Object[Sample,"EvaporateOptions Test Water Sample2 "<>$SessionUUID],
				Object[Sample,"EvaporateOptions Test Water Sample3 "<>$SessionUUID],
				Object[Sample,"EvaporateOptions Test Water Sample4 "<>$SessionUUID]
			};

			EraseObject[
				PickList[namedObjects,DatabaseMemberQ[namedObjects]],
				Force->True,
				Verbose->False
			]
		];

		Module[{testPlate,waterSample,waterSample2,waterSample3,waterSample4},
			(* Create some containers *)
			testPlate=Upload[<|
				Type->Object[Container,Plate],
				Model->Link[Model[Container,Plate,"96-well 2mL Deep Well Plate"],Objects],
				Name->"EvaporateOptions Test Plate "<>$SessionUUID,
				Site->Link[$Site],
				DeveloperObject->True
			|>];

			(* Create some samples *)
			{
				waterSample,
				waterSample2,
				waterSample3,
				waterSample4
			}=ECL`InternalUpload`UploadSample[
				{
					Model[Sample,"Milli-Q water"],
					Model[Sample,"Milli-Q water"],
					Model[Sample,"Milli-Q water"],
					Model[Sample,"Milli-Q water"]
				},
				{
					{"A1",testPlate},
					{"A2",testPlate},
					{"A3",testPlate},
					{"B1",testPlate}
				},
				InitialAmount->{
					10 Microliter,
					100 Microliter,
					1 Milliliter,
					1.75 Milliliter
				},
				StorageCondition->AmbientStorage
			];

			(* Secondary uploads *)
			Upload[{
				<|Object->waterSample,Name->"EvaporateOptions Test Water Sample "<>$SessionUUID,Status->Available,DeveloperObject->True|>,
				<|Object->waterSample2,Name->"EvaporateOptions Test Water Sample2 "<>$SessionUUID,Status->Available,DeveloperObject->True|>,
				<|Object->waterSample3,Name->"EvaporateOptions Test Water Sample3 "<>$SessionUUID,Status->Available,DeveloperObject->True|>,
				<|Object->waterSample4,Name->"EvaporateOptions Test Water Sample4 "<>$SessionUUID,Status->Available,DeveloperObject->True|>
			}];
		]
	},

	SymbolTearDown :> {
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
	}
];


(* ::Subsection:: *)
(*ValidExperimentEvaporateQ*)


DefineTests[
	ValidExperimentEvaporateQ,
	{
		Example[{Basic,"Verify that the experiment can be run without issue:"},
			ValidExperimentEvaporateQ[{Object[Sample,"ValidExperimentEvaporateQ Test Water Sample "<>$SessionUUID],Object[Sample,"ValidExperimentEvaporateQ Test Water Sample2 "<>$SessionUUID]}],
			True
		],
		Example[{Basic,"Return False if there are problems with the inputs or options:"},
			ValidExperimentEvaporateQ[{Object[Sample,"ValidExperimentEvaporateQ Test Water Sample "<>$SessionUUID],Object[Sample,"ValidExperimentEvaporateQ Test Water Sample2 "<>$SessionUUID]},
				EvaporationTemperature -> 95*Celsius,
				EvaporationType->SpeedVac
			],
			False
		],
		Example[{Options,OutputFormat,"Return a test summary:"},
			ValidExperimentEvaporateQ[Object[Sample,"ValidExperimentEvaporateQ Test Water Sample "<>$SessionUUID],OutputFormat->TestSummary],
			_EmeraldTestSummary
		],
		Example[{Options,Verbose,"Print verbose messages reporting test passage/failure:"},
			ValidExperimentEvaporateQ[Object[Sample,"ValidExperimentEvaporateQ Test Water Sample "<>$SessionUUID],Verbose->True],
			True
		]
	},
	Stubs:>{
		(* I am an important stub that prevents the tester from getting a bunch of notifications *)
		$PersonID=Object[User,"Test user for notebook-less test protocols"],

		(* ValidObjectQ is super slow so just doing this here *)
		ValidObjectQ[objs_,OutputFormat->Boolean]:=ConstantArray[True,Length[objs]]
	},
	SymbolSetUp:>{
		$CreatedObjects = {};

		(* IMPORTANT: Make sure that any objects you upload have DeveloperObject->True. *)
		(* Erase any objects that we failed to erase in the last unit test. *)
		Module[{namedObjects},
			namedObjects={
				Object[Container,Plate,"ValidExperimentEvaporateQ Test Plate "<>$SessionUUID],
				Object[Sample,"ValidExperimentEvaporateQ Test Water Sample "<>$SessionUUID],
				Object[Sample,"ValidExperimentEvaporateQ Test Water Sample2 "<>$SessionUUID],
				Object[Sample,"ValidExperimentEvaporateQ Test Water Sample3 "<>$SessionUUID],
				Object[Sample,"ValidExperimentEvaporateQ Test Water Sample4 "<>$SessionUUID]
			};

			EraseObject[
				PickList[namedObjects,DatabaseMemberQ[namedObjects]],
				Force->True,
				Verbose->False
			]
		];
		Module[
			{testPlate,waterSample,waterSample2,waterSample3,waterSample4},

			(* Create some containers *)
			{
				testPlate
			} = Upload[{
				<|Type->Object[Container,Plate],Model->Link[Model[Container,Plate,"96-well 2mL Deep Well Plate"],Objects],Name->"ValidExperimentEvaporateQ Test Plate "<>$SessionUUID,Site->Link[$Site],DeveloperObject->True|>
			}];

			(* Create some samples *)
			{
				waterSample,
				waterSample2,
				waterSample3,
				waterSample4
			} = ECL`InternalUpload`UploadSample[
				{
					Model[Sample,"Milli-Q water"],
					Model[Sample,"Milli-Q water"],
					Model[Sample,"Milli-Q water"],
					Model[Sample,"Milli-Q water"]
				},
				{
					{"A1",testPlate},
					{"A2",testPlate},
					{"A3",testPlate},
					{"B1",testPlate}
				},
				InitialAmount->{
					10 Microliter,
					100 Microliter,
					1 Milliliter,
					1.75 Milliliter
				},
				StorageCondition -> AmbientStorage
			];

			(* Secondary uploads *)
			Upload[{
				<|Object->waterSample,Name->"ValidExperimentEvaporateQ Test Water Sample "<>$SessionUUID,Status->Available,DeveloperObject->True|>,
				<|Object->waterSample2,Name->"ValidExperimentEvaporateQ Test Water Sample2 "<>$SessionUUID,Status->Available,DeveloperObject->True|>,
				<|Object->waterSample3,Name->"ValidExperimentEvaporateQ Test Water Sample3 "<>$SessionUUID,Status->Available,DeveloperObject->True|>,
				<|Object->waterSample4,Name->"ValidExperimentEvaporateQ Test Water Sample4 "<>$SessionUUID,Status->Available,DeveloperObject->True|>
			}];
		];
	},

	SymbolTearDown :> {
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
	}
];
