(* ::Subsection:: *)
(*ExperimentMeasureViscosityPreview*)


DefineTests[
	ExperimentMeasureViscosityPreview,
	{
		Example[{Basic,"No preview is currently available for ExperimentMeasureViscosity:"},
			ExperimentMeasureViscosityPreview[{Object[Sample,"MeasureViscosityPreview Test Water Sample"<>$SessionUUID],Object[Sample,"MeasureViscosityPreview Test Water Sample2"<>$SessionUUID]}],
			Null
		],
		Example[{Additional,"If you wish to understand how the experiment will be performed try using ExperimentMeasureViscosityOptions:"},
			ExperimentMeasureViscosityOptions[{Object[Sample,"MeasureViscosityPreview Test Water Sample3"<>$SessionUUID],Object[Sample,"MeasureViscosityPreview Test Water Sample4"<>$SessionUUID]}],
			_Grid
		],
		Example[{Additional,"The inputs and options can also be checked to verify that the experiment can be safely run by using ValidExperimentMeasureViscosityQ:"},
			ValidExperimentMeasureViscosityQ[{Object[Sample,"MeasureViscosityPreview Test Water Sample"<>$SessionUUID],Object[Sample,"MeasureViscosityPreview Test Water Sample2"<>$SessionUUID]},Verbose->Failures],
			True
		]
	},
	Stubs:>{
		(* I am an important stub that prevents the tester from getting a bunch of notifications *)
		$PersonID=Object[User,"Test user for notebook-less test protocols"]
	},
	SymbolSetUp:>{
		$CreatedObjects = {};

		Off[Warning::SamplesOutOfStock];
		Off[Warning::InstrumentUndergoingMaintenance];

		(* IMPORTANT: Make sure that any objects you upload have DeveloperObject->True. *)
		(* Erase any objects that we failed to erase in the last unit test. *)
		Module[{namedObjects},
			namedObjects={
				Object[Container,Plate,"MeasureViscosityPreview Test Plate"<>$SessionUUID],
				Object[Container,Vessel,"MeasureViscosityPreview Test Vial 1"<>$SessionUUID],
				Object[Container,Vessel,"MeasureViscosityPreview Test Vial 2"<>$SessionUUID],
				Object[Sample,"MeasureViscosityPreview Test Water Sample"<>$SessionUUID],
				Object[Sample,"MeasureViscosityPreview Test Water Sample2"<>$SessionUUID],
				Object[Sample,"MeasureViscosityPreview Test Water Sample3"<>$SessionUUID],
				Object[Sample,"MeasureViscosityPreview Test Water Sample4"<>$SessionUUID]
			};

			EraseObject[
				PickList[namedObjects,DatabaseMemberQ[namedObjects]],
				Force->True,
				Verbose->False
			]
		];

	Module[{testPlate,testVial1,testVial2,waterSample,waterSample2,waterSample3,waterSample4},
		(* Create some containers *)
		{
			testPlate,
			testVial1,
			testVial2
		} = Upload[{
			<|Type->Object[Container,Plate],Model->Link[Model[Container,Plate,"96-well PCR Plate"],Objects],Name->"MeasureViscosityPreview Test Plate"<>$SessionUUID,DeveloperObject->True,Site->Link[$Site]|>,
			<|Type->Object[Container,Vessel],Model->Link[Model[Container,Vessel,"1mL HPLC Vial (total recovery) with Cap and PTFE/Silicone Septum"],Objects],Name->"MeasureViscosityPreview Test Vial 1"<>$SessionUUID,DeveloperObject->True,Site->Link[$Site]|>,
			<|Type->Object[Container,Vessel],Model->Link[Model[Container,Vessel,"1mL HPLC Vial (total recovery) with Cap and PTFE/Silicone Septum"],Objects],Name->"MeasureViscosityPreview Test Vial 2"<>$SessionUUID,DeveloperObject->True,Site->Link[$Site]|>
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
				{"A1",testVial1},
				{"A1",testVial2}
			},
			InitialAmount->{
				100 Microliter,
				90 Microliter,
				200 Microliter,
				175 Microliter
			},
			StorageCondition -> AmbientStorage
		];

		(* Secondary uploads *)
		Upload[{
			<|Object->waterSample,Name->"MeasureViscosityPreview Test Water Sample"<>$SessionUUID,Status->Available,DeveloperObject->True|>,
			<|Object->waterSample2,Name->"MeasureViscosityPreview Test Water Sample2"<>$SessionUUID,Status->Available,DeveloperObject->True|>,
			<|Object->waterSample3,Name->"MeasureViscosityPreview Test Water Sample3"<>$SessionUUID,Status->Available,DeveloperObject->True|>,
			<|Object->waterSample4,Name->"MeasureViscosityPreview Test Water Sample4"<>$SessionUUID,Status->Available,DeveloperObject->True|>
		}];
		]
	},
	Stubs :> {$PersonID = Object[User, "Test user for notebook-less test protocols"]},

	SymbolTearDown :> {
		On[Warning::SamplesOutOfStock];
		On[Warning::InstrumentUndergoingMaintenance];

		(* Erase all objects that were created in the course of these tests *)
		EraseObject[
			PickList[	$CreatedObjects,
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
(*ExperimentMeasureViscosityOptions*)


DefineTests[
	ExperimentMeasureViscosityOptions,
	{
		Example[{Basic,"Display the option values which will be used in the experiment:"},
			ExperimentMeasureViscosityOptions[{Object[Sample,"MeasureViscosityOptions Test Water Sample"<>$SessionUUID],Object[Sample,"MeasureViscosityOptions Test Water Sample2"<>$SessionUUID]}],
			_Grid
		],
		Example[{Basic,"Any potential issues with provided inputs/options will be displayed:"},
			ExperimentMeasureViscosityOptions[{Object[Sample,"MeasureViscosityOptions Test Water Sample3"<>$SessionUUID]},	RemeasurementAllowed->True, RemeasurementReloadVolume->Null],
			_Grid,
			Messages:>{Error::InvalidOption, Error::ViscosityRemeasurementAllowedConflict}
		],
		Example[
			{Options,OutputFormat,"If OutputFormat -> List, return a list of options:"},
			ExperimentMeasureViscosityOptions[{Object[Sample,"MeasureViscosityOptions Test Water Sample4"<>$SessionUUID]},OutputFormat->List],
			{(_Rule|_RuleDelayed)..}
		]
	},
	Stubs:>{
		(* I am an important stub that prevents the tester from getting a bunch of notifications *)
		$PersonID=Object[User,"Test user for notebook-less test protocols"]
	},
	SymbolSetUp:>{
		$CreatedObjects = {};

		Off[Warning::SamplesOutOfStock];
		Off[Warning::InstrumentUndergoingMaintenance];

		(* IMPORTANT: Make sure that any objects you upload have DeveloperObject->True. *)
		(* Erase any objects that we failed to erase in the last unit test. *)
		Module[{namedObjects},
			namedObjects={
				Object[Container,Plate,"MeasureViscosityOptions Test Plate"<>$SessionUUID],
				Object[Container,Vessel,"MeasureViscosityOptions Test Vial 1"<>$SessionUUID],
				Object[Container,Vessel,"MeasureViscosityOptions Test Vial 2"<>$SessionUUID],
				Object[Sample,"MeasureViscosityOptions Test Water Sample"<>$SessionUUID],
				Object[Sample,"MeasureViscosityOptions Test Water Sample2"<>$SessionUUID],
				Object[Sample,"MeasureViscosityOptions Test Water Sample3"<>$SessionUUID],
				Object[Sample,"MeasureViscosityOptions Test Water Sample4"<>$SessionUUID]
			};

			EraseObject[
				PickList[namedObjects,DatabaseMemberQ[namedObjects]],
				Force->True,
				Verbose->False
			]
		];

		Module[{testPlate,testVial1,testVial2,waterSample,waterSample2,waterSample3,waterSample4},

			(* Create some containers *)
			{
				testPlate,
				testVial1,
				testVial2
			} = Upload[{
				<|Type->Object[Container,Plate],Model->Link[Model[Container,Plate,"96-well PCR Plate"],Objects],Name->"MeasureViscosityOptions Test Plate"<>$SessionUUID,DeveloperObject->True,Site->Link[$Site]|>,
				<|Type->Object[Container,Vessel],Model->Link[Model[Container,Vessel,"1mL HPLC Vial (total recovery) with Cap and PTFE/Silicone Septum"],Objects],Name->"MeasureViscosityOptions Test Vial 1"<>$SessionUUID,DeveloperObject->True,Site->Link[$Site]|>,
				<|Type->Object[Container,Vessel],Model->Link[Model[Container,Vessel,"1mL HPLC Vial (total recovery) with Cap and PTFE/Silicone Septum"],Objects],Name->"MeasureViscosityOptions Test Vial 2"<>$SessionUUID,DeveloperObject->True,Site->Link[$Site]|>
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
					50 Microliter,
					100 Microliter,
					98 Microliter,
					75 Microliter
				},
				StorageCondition -> AmbientStorage
			];

			(* Secondary uploads *)
			Upload[{
				<|Object->waterSample,Name->"MeasureViscosityOptions Test Water Sample"<>$SessionUUID,Status->Available,DeveloperObject->True|>,
				<|Object->waterSample2,Name->"MeasureViscosityOptions Test Water Sample2"<>$SessionUUID,Status->Available,DeveloperObject->True|>,
				<|Object->waterSample3,Name->"MeasureViscosityOptions Test Water Sample3"<>$SessionUUID,Status->Available,DeveloperObject->True|>,
				<|Object->waterSample4,Name->"MeasureViscosityOptions Test Water Sample4"<>$SessionUUID,Status->Available,DeveloperObject->True|>
			}];
		]
	},

	SymbolTearDown :> {
		On[Warning::SamplesOutOfStock];
		On[Warning::InstrumentUndergoingMaintenance];

		(* Erase all objects that were created in the course of these tests *)
		EraseObject[
			PickList[	$CreatedObjects,
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
(*ValidExperimentMeasureViscosityQ*)


DefineTests[
	ValidExperimentMeasureViscosityQ,
	{
		Example[{Basic,"Verify that the experiment can be run without issue:"},
			ValidExperimentMeasureViscosityQ[{Object[Sample,"ValidExperimentMeasureViscosityQ Test Water Sample"<>$SessionUUID],Object[Sample,"ValidExperimentMeasureViscosityQ Test Water Sample2"<>$SessionUUID]}],
			True
		],
		Example[{Basic,"Return False if there are problems with the inputs or options:"},
			ValidExperimentMeasureViscosityQ[Object[Sample,"ValidExperimentMeasureViscosityQ Test Water Sample3"<>$SessionUUID],
				InjectionVolume->90 Microliter
			],
			False
		],
		Example[{Options,OutputFormat,"Return a test summary:"},
			ValidExperimentMeasureViscosityQ[Object[Sample,"ValidExperimentMeasureViscosityQ Test Water Sample4"<>$SessionUUID],OutputFormat->TestSummary],
			_EmeraldTestSummary
		],
		Example[{Options,Verbose,"Print verbose messages reporting test passage/failure:"},
			ValidExperimentMeasureViscosityQ[Object[Sample,"ValidExperimentMeasureViscosityQ Test Water Sample4"<>$SessionUUID],Verbose->True],
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

		Off[Warning::SamplesOutOfStock];
		Off[Warning::InstrumentUndergoingMaintenance];

		(* IMPORTANT: Make sure that any objects you upload have DeveloperObject->True. *)
		(* Erase any objects that we failed to erase in the last unit test. *)
		Module[{namedObjects},
			namedObjects={
				Object[Container,Plate,"ValidExperimentMeasureViscosityQ Test Plate"<>$SessionUUID],
				Object[Container,Vessel,"ValidExperimentMeasureViscosityQ Test Vial 1"<>$SessionUUID],
				Object[Container,Vessel,"ValidExperimentMeasureViscosityQ Test Vial 2"<>$SessionUUID],
				Object[Sample,"ValidExperimentMeasureViscosityQ Test Water Sample"<>$SessionUUID],
				Object[Sample,"ValidExperimentMeasureViscosityQ Test Water Sample2"<>$SessionUUID],
				Object[Sample,"ValidExperimentMeasureViscosityQ Test Water Sample3"<>$SessionUUID],
				Object[Sample,"ValidExperimentMeasureViscosityQ Test Water Sample4"<>$SessionUUID]
			};

			EraseObject[
				PickList[namedObjects,DatabaseMemberQ[namedObjects]],
				Force->True,
				Verbose->False
			]
		];

	Module[{testPlate,testVial1,testVial2,waterSample,waterSample2,waterSample3,waterSample4},
		(* Create some containers *)
		{
			testPlate,
			testVial1,
			testVial2
		} = Upload[{
			<|Type->Object[Container,Plate],Model->Link[Model[Container,Plate,"96-well PCR Plate"],Objects],Name->"ValidExperimentMeasureViscosityQ Test Plate"<>$SessionUUID,DeveloperObject->True,Site->Link[$Site]|>,
			<|Type->Object[Container,Vessel],Model->Link[Model[Container,Vessel,"1mL HPLC Vial (total recovery) with Cap and PTFE/Silicone Septum"],Objects],Name->"ValidExperimentMeasureViscosityQ Test Vial 1"<>$SessionUUID,DeveloperObject->True,Site->Link[$Site]|>,
			<|Type->Object[Container,Vessel],Model->Link[Model[Container,Vessel,"1mL HPLC Vial (total recovery) with Cap and PTFE/Silicone Septum"],Objects],Name->"ValidExperimentMeasureViscosityQ Test Vial 2"<>$SessionUUID,DeveloperObject->True,Site->Link[$Site]|>
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
				{"A1",testVial1},
				{"A1",testVial2}
			},
			InitialAmount->{
				50 Microliter,
				100 Microliter,
				50 Microliter,
				75 Microliter
			},
			StorageCondition -> AmbientStorage
		];

		(* Secondary uploads *)
		Upload[{
			<|Object->waterSample,Name->"ValidExperimentMeasureViscosityQ Test Water Sample"<>$SessionUUID,Status->Available,DeveloperObject->True,ExpirationDate->Now + 5 Year|>,
			<|Object->waterSample2,Name->"ValidExperimentMeasureViscosityQ Test Water Sample2"<>$SessionUUID,Status->Available,DeveloperObject->True,ExpirationDate->Now + 5 Year|>,
			<|Object->waterSample3,Name->"ValidExperimentMeasureViscosityQ Test Water Sample3"<>$SessionUUID,Status->Available,DeveloperObject->True,ExpirationDate->Now + 5 Year|>,
			<|Object->waterSample4,Name->"ValidExperimentMeasureViscosityQ Test Water Sample4"<>$SessionUUID,Status->Available,DeveloperObject->True,ExpirationDate->Now + 5 Year|>
		}];
	]
	},

	SymbolTearDown :> {
		On[Warning::SamplesOutOfStock];
		On[Warning::InstrumentUndergoingMaintenance];

		(* Erase all objects that were created in the course of these tests *)
		EraseObject[
			PickList[	$CreatedObjects,
				DatabaseMemberQ[$CreatedObjects]
			],
			Force->True,
			Verbose->False
		];
		(* Cleanse $CreatedObjects *)
		Unset[$CreatedObjects];
	}
];
