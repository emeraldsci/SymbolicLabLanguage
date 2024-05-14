(* ::Subsection:: *)
(*ExperimentLyophilizePreview*)


DefineTests[
	ExperimentLyophilizePreview,
	{
		Example[{Basic,"No preview is currently available for ExperimentLyophilize:"},
			ExperimentLyophilizePreview[{Object[Sample,"ExperimentLyophilizePreview Test Water Sample " <> $SessionUUID],Object[Sample,"ExperimentLyophilizePreview Test Water Sample2 " <> $SessionUUID]}],
			Null
		],
		Example[{Additional,"If you wish to understand how the experiment will be performed try using ExperimentLyophilizeOptions:"},
			ExperimentLyophilizeOptions[{Object[Sample,"ExperimentLyophilizePreview Test Water Sample " <> $SessionUUID],Object[Sample,"ExperimentLyophilizePreview Test Water Sample2 " <> $SessionUUID]}],
			_Grid
		],
		Example[{Additional,"The inputs and options can also be checked to verify that the experiment can be safely run:"},
			ValidExperimentLyophilizeQ[{Object[Sample,"ExperimentLyophilizePreview Test Water Sample " <> $SessionUUID],Object[Sample,"ExperimentLyophilizePreview Test Water Sample2 " <> $SessionUUID]},Verbose->Failures],
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
				Object[Container,Plate,"ExperimentLyophilizePreview Test Plate " <> $SessionUUID],
				Object[Container,Vessel,"ExperimentLyophilizePreview Immobile Container " <> $SessionUUID],
				Object[Container,Vessel,"ExperimentLyophilizePreview Non Immobile Container " <> $SessionUUID],
				Object[Container,Vessel,"ExperimentLyophilizePreview Non Immobile Container 2 " <> $SessionUUID],
				Object[Container,Vessel,"ExperimentLyophilizePreview Immobile Container 2 " <> $SessionUUID],
				Object[Container,Vessel,"ExperimentLyophilizePreview Test 50mL 1 " <> $SessionUUID],
				Object[Container,Vessel,"ExperimentLyophilizePreview Test 50mL 2 " <> $SessionUUID],
				Object[Sample,"ExperimentLyophilizePreview Test Water Sample " <> $SessionUUID],
				Object[Sample,"ExperimentLyophilizePreview Test Water Sample2 " <> $SessionUUID],
				Object[Sample,"ExperimentLyophilizePreview Test Water Sample3 " <> $SessionUUID],
				Object[Sample,"ExperimentLyophilizePreview Test Water Sample4 " <> $SessionUUID],
				Object[Sample,"ExperimentLyophilizePreview Test Water Sample5 " <> $SessionUUID],
				Object[Sample,"ExperimentLyophilizePreview Test DCM Sample " <> $SessionUUID],
				Object[Sample,"ExperimentLyophilizePreview Test DCM Sample2 " <> $SessionUUID],
				Object[Protocol,HPLC,"Parent Protocol for ExperimentLyophilizePreview testing " <> $SessionUUID]
			};

			EraseObject[
				PickList[namedObjects,DatabaseMemberQ[namedObjects]],
				Force->True,
				Verbose->False
			]
		];

		(* Create an ID for the Model[Container,Vessel] we're gonna make below*)
		fakeNewModelID = CreateID[Model[Container,Vessel]];

		(* Create some containers *)
		{
			testPlate,
			fiftyMLtube1,
			fiftyMLtube2
		} = Upload[{
			<|
				Type->Object[Container,Plate],
				Model->Link[Model[Container,Plate,"96-well 2mL Deep Well Plate"],Objects],
				Name->"ExperimentLyophilizePreview Test Plate " <> $SessionUUID,
				Site->Link[$Site],
				DeveloperObject->True
			|>,
			<|
				Type->Object[Container,Vessel],
				Model->Link[Model[Container,Vessel,"id:bq9LA0dBGGR6"],Objects],
				Name->"ExperimentLyophilizePreview Test 50mL 1 " <> $SessionUUID,
				Site->Link[$Site],
				DeveloperObject->True
			|>,
			<|
				Type->Object[Container,Vessel],
				Model->Link[Model[Container,Vessel,"id:bq9LA0dBGGR6"],Objects],
				Name->"ExperimentLyophilizePreview Test 50mL 2 " <> $SessionUUID,
				Site->Link[$Site],
				DeveloperObject->True
			|>
		}];

		(* Create some samples *)
		{
			waterSample,
			waterSample2,
			waterSample3,
			waterSample4,
			waterSample5,
			dcmSamp1,
			dcmSamp2
		} = ECL`InternalUpload`UploadSample[
			{
				Model[Sample,"Milli-Q water"],
				Model[Sample,"Milli-Q water"],
				Model[Sample,"Milli-Q water"],
				Model[Sample,"Milli-Q water"],
				Model[Sample,"Milli-Q water"],
				Model[Sample,"Dichloromethane, Anhydrous"],
				Model[Sample,"Dichloromethane, Anhydrous"]
			},
			{
				{"A1",testPlate},
				{"A2",testPlate},
				{"A3",testPlate},
				{"B1",testPlate},
				{"B2",testPlate},
				{"A1",fiftyMLtube1},
				{"A1",fiftyMLtube2}
			},
			InitialAmount->{
				10 Microliter,
				100 Microliter,
				1 Milliliter,
				1.9 Milliliter,
				1.5 Milliliter,
				30 Milliliter,
				45 Milliliter
			},
			StorageCondition -> AmbientStorage
		];

		(* Secondary uploads *)
		Upload[{
			<|Object->waterSample,Name->"ExperimentLyophilizePreview Test Water Sample " <> $SessionUUID,Status->Available,DeveloperObject->True|>,
			<|Object->waterSample2,Name->"ExperimentLyophilizePreview Test Water Sample2 " <> $SessionUUID,Status->Available,DeveloperObject->True|>,
			<|Object->waterSample3,Name->"ExperimentLyophilizePreview Test Water Sample3 " <> $SessionUUID,Status->Available,DeveloperObject->True|>,
			<|Object->waterSample4,Name->"ExperimentLyophilizePreview Test Water Sample4 " <> $SessionUUID,Status->Available,DeveloperObject->True|>,
			<|Object->waterSample5,Name->"ExperimentLyophilizePreview Test Water Sample5 " <> $SessionUUID,Status->Available,DeveloperObject->True|>,
			<|Object->dcmSamp1,Name->"ExperimentLyophilizePreview Test DCM Sample " <> $SessionUUID,Status->Available,DeveloperObject->True|>,
			<|Object->dcmSamp2,Name->"ExperimentLyophilizePreview Test DCM Sample2 " <> $SessionUUID,Status->Available,DeveloperObject->True|>
		}];

		(* Upload 50 2ml tubes for batching checks *)
		myMV2mLSet = ConstantArray[
			<|
				Type->Object[Container,Vessel],
				Model->Link[Model[Container,Vessel,"2mL Tube"],Objects],
				Site->Link[$Site],
				DeveloperObject->True
			|>,
			50
		];

		myMV2mLTubes = Upload[myMV2mLSet];

		ECL`InternalUpload`UploadSample[
			ConstantArray[Model[Sample,"Milli-Q water"],Length[myMV2mLTubes]],
			{"A1",#}&/@myMV2mLTubes,
			InitialAmount -> ConstantArray[300*Microliter,Length[myMV2mLTubes]],
			StorageCondition -> Refrigerator
		];

		immobileSetUp = Module[{modelVesselID,model,vessel1,vessel2,protocol},

			modelVesselID=CreateID[Model[Container,Vessel]];
			{model,vessel1,vessel2,protocol}=Upload[{
				<|
					Object->modelVesselID,
					Replace[Positions] ->{<|Name -> "A1", Footprint -> Null,MaxWidth -> .1 Meter,MaxDepth -> .1 Meter,MaxHeight -> .1 Meter|>},
					Immobile->True
				|>,
				<|
					Type->Object[Container,Vessel],
					Model->Link[modelVesselID,Objects],
					DeveloperObject->True,
					Site->Link[$Site],
					Name->"ExperimentLyophilizePreview Immobile Container " <> $SessionUUID
				|>,
				<|
					Type->Object[Container,Vessel],
					Model->Link[Model[Container,Vessel,"2mL Tube"],Objects],
					DeveloperObject->True,
					Site->Link[$Site],
					Name->"ExperimentLyophilizePreview Non Immobile Container " <> $SessionUUID
				|>,
				<|
					Type->Object[Protocol,HPLC],
					Name->"Parent Protocol for ExperimentLyophilizePreview testing " <> $SessionUUID
				|>
			}];

			UploadSample[{Model[Sample,"Milli-Q water"],Model[Sample,"Milli-Q water"]},{{"A1",vessel1},{"A1",vessel2}}];
		];

		immobileSetUp2 = Module[{modelVesselID,model,vessel1,vessel2},

			modelVesselID=CreateID[Model[Container,Vessel]];
			{model,vessel1,vessel2}=Upload[{
				<|
					Object->modelVesselID,
					Replace[Positions] ->{<|Name -> "A1", Footprint -> Null,MaxWidth -> .1 Meter,MaxDepth -> .1 Meter,MaxHeight -> .1 Meter|>},
					Immobile->True
				|>,
				<|
					Type->Object[Container,Vessel],
					Model->Link[modelVesselID,Objects],
					DeveloperObject->True,
					Site->Link[$Site],
					Name->"ExperimentLyophilizePreview Immobile Container 2 " <> $SessionUUID,
					TareWeight->10 Gram
				|>,
				<|
					Type->Object[Container,Vessel],
					Model->Link[Model[Container,Vessel,"2mL Tube"],Objects],
					DeveloperObject->True,
					Site->Link[$Site],
					Name->"ExperimentLyophilizePreview Non Immobile Container 2 " <> $SessionUUID,
					TareWeight->10 Gram
				|>
			}];

			UploadSample[{Model[Sample,"Milli-Q water"],Model[Sample,"Milli-Q water"]},{{"A1",vessel1},{"A1",vessel2}}];
		];
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
(*ExperimentLyophilizeOptions*)


DefineTests[
	ExperimentLyophilizeOptions,
	{
		Example[{Basic,"Display the option values which will be used in the experiment:"},
			ExperimentLyophilizeOptions[{Object[Sample,"ExperimentLyophilizeOptions Test Water Sample " <> $SessionUUID]}],
			_Grid
		],
		Example[{Basic,"Any potential issues with provided inputs/options will be displayed:"},
			ExperimentLyophilizeOptions[{Object[Sample,"ExperimentLyophilizeOptions Discarded Test Water Sample " <> $SessionUUID]}],
			_Grid,
			Messages:>{Error::DiscardedSamples,Error::InvalidInput}
		],
		Example[
			{Options,OutputFormat,"If OutputFormat -> List, return a list of options:"},
			ExperimentLyophilizeOptions[{Object[Sample,"ExperimentLyophilizeOptions Test Water Sample " <> $SessionUUID]},OutputFormat->List],
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
				Object[Container,Plate,"ExperimentLyophilizeOptions Test Plate " <> $SessionUUID],
				Object[Container,Vessel,"ExperimentLyophilizeOptions Immobile Container " <> $SessionUUID],
				Object[Container,Vessel,"ExperimentLyophilizeOptions Non Immobile Container " <> $SessionUUID],
				Object[Container,Vessel,"ExperimentLyophilizeOptions Non Immobile Container 2 " <> $SessionUUID],
				Object[Container,Vessel,"ExperimentLyophilizeOptions Immobile Container 2 " <> $SessionUUID],
				Object[Container,Vessel,"ExperimentLyophilizeOptions Test 50mL 1 " <> $SessionUUID],
				Object[Container,Vessel,"ExperimentLyophilizeOptions Test 50mL 2 " <> $SessionUUID],
				Object[Sample,"ExperimentLyophilizeOptions Test Water Sample " <> $SessionUUID],
				Object[Sample,"ExperimentLyophilizeOptions Discarded Test Water Sample " <> $SessionUUID],
				Object[Sample,"ExperimentLyophilizeOptions Test Water Sample3 " <> $SessionUUID],
				Object[Sample,"ExperimentLyophilizeOptions Test Water Sample4 " <> $SessionUUID],
				Object[Sample,"ExperimentLyophilizeOptions Test Water Sample5 " <> $SessionUUID],
				Object[Sample,"ExperimentLyophilizeOptions Test DCM Sample " <> $SessionUUID],
				Object[Sample,"ExperimentLyophilizeOptions Test DCM Sample2 " <> $SessionUUID],
				Object[Protocol,HPLC,"Parent Protocol for ExperimentLyophilizeOptions testing " <> $SessionUUID]
			};

			EraseObject[
				PickList[namedObjects,DatabaseMemberQ[namedObjects]],
				Force->True,
				Verbose->False
			]
		];

		(* Create an ID for the Model[Container,Vessel] we're gonna make below*)
		fakeNewModelID = CreateID[Model[Container,Vessel]];

		(* Create some containers *)
		{
			testPlate,
			fiftyMLtube1,
			fiftyMLtube2
		} = Upload[{
			<|
				Type->Object[Container,Plate],
				Model->Link[Model[Container,Plate,"96-well 2mL Deep Well Plate"],Objects],
				Name->"ExperimentLyophilizeOptions Test Plate " <> $SessionUUID,
				Site->Link[$Site],
				DeveloperObject->True
			|>,
			<|
				Type->Object[Container,Vessel],
				Model->Link[Model[Container,Vessel,"id:bq9LA0dBGGR6"],Objects],
				Name->"ExperimentLyophilizeOptions Test 50mL 1 " <> $SessionUUID,
				Site->Link[$Site],
				DeveloperObject->True
			|>,
			<|
				Type->Object[Container,Vessel],
				Model->Link[Model[Container,Vessel,"id:bq9LA0dBGGR6"],Objects],
				Name->"ExperimentLyophilizeOptions Test 50mL 2 " <> $SessionUUID,
				Site->Link[$Site],
				DeveloperObject->True
			|>
		}];

		(* Create some samples *)
		{
			waterSample,
			waterSample2,
			waterSample3,
			waterSample4,
			waterSample5,
			dcmSamp1,
			dcmSamp2
		} = ECL`InternalUpload`UploadSample[
			{
				Model[Sample,"Milli-Q water"],
				Model[Sample,"Milli-Q water"],
				Model[Sample,"Milli-Q water"],
				Model[Sample,"Milli-Q water"],
				Model[Sample,"Milli-Q water"],
				Model[Sample,"Dichloromethane, Anhydrous"],
				Model[Sample,"Dichloromethane, Anhydrous"]
			},
			{
				{"A1",testPlate},
				{"A2",testPlate},
				{"A3",testPlate},
				{"B1",testPlate},
				{"B2",testPlate},
				{"A1",fiftyMLtube1},
				{"A1",fiftyMLtube2}
			},
			InitialAmount->{
				10 Microliter,
				10 Microliter,
				1 Milliliter,
				1.9 Milliliter,
				1.5 Milliliter,
				30 Milliliter,
				45 Milliliter
			},
			StorageCondition -> AmbientStorage
		];

		(* Secondary uploads *)
		Upload[{
			<|Object->waterSample,Name->"ExperimentLyophilizeOptions Test Water Sample " <> $SessionUUID,Status->Available,DeveloperObject->True|>,
			<|Object->waterSample2,Name->"ExperimentLyophilizeOptions Discarded Test Water Sample " <> $SessionUUID,Status->Discarded,DeveloperObject->True|>,
			<|Object->waterSample3,Name->"ExperimentLyophilizeOptions Test Water Sample3 " <> $SessionUUID,Status->Available,DeveloperObject->True|>,
			<|Object->waterSample4,Name->"ExperimentLyophilizeOptions Test Water Sample4 " <> $SessionUUID,Status->Available,DeveloperObject->True|>,
			<|Object->waterSample5,Name->"ExperimentLyophilizeOptions Test Water Sample5 " <> $SessionUUID,Status->Available,DeveloperObject->True|>,
			<|Object->dcmSamp1,Name->"ExperimentLyophilizeOptions Test DCM Sample " <> $SessionUUID,Status->Available,DeveloperObject->True|>,
			<|Object->dcmSamp2,Name->"ExperimentLyophilizeOptions Test DCM Sample2 " <> $SessionUUID,Status->Available,DeveloperObject->True|>
		}];

		(* Upload 50 2ml tubes for batching checks *)
		myMV2mLSet = ConstantArray[
			<|
				Type->Object[Container,Vessel],
				Model->Link[Model[Container,Vessel,"2mL Tube"],Objects],
				Site->Link[$Site],
				DeveloperObject->True|>,
			50
		];

		myMV2mLTubes = Upload[myMV2mLSet];

		ECL`InternalUpload`UploadSample[
			ConstantArray[Model[Sample,"Milli-Q water"],Length[myMV2mLTubes]],
			{"A1",#}&/@myMV2mLTubes,
			InitialAmount -> ConstantArray[300*Microliter,Length[myMV2mLTubes]],
			StorageCondition -> Refrigerator
		];

		immobileSetUp = Module[{modelVesselID,model,vessel1,vessel2,protocol},

			modelVesselID=CreateID[Model[Container,Vessel]];
			{model,vessel1,vessel2,protocol}=Upload[{
				<|
					Object->modelVesselID,
					Replace[Positions] ->{<|Name -> "A1", Footprint -> Null,MaxWidth -> .1 Meter,MaxDepth -> .1 Meter,MaxHeight -> .1 Meter|>},
					Immobile->True
				|>,
				<|
					Type->Object[Container,Vessel],
					Model->Link[modelVesselID,Objects],
					DeveloperObject->True,
					Site->Link[$Site],
					Name->"ExperimentLyophilizeOptions Immobile Container " <> $SessionUUID
				|>,
				<|
					Type->Object[Container,Vessel],
					Model->Link[Model[Container,Vessel,"2mL Tube"],Objects],
					DeveloperObject->True,
					Site->Link[$Site],
					Name->"ExperimentLyophilizeOptions Non Immobile Container " <> $SessionUUID
				|>,
				<|
					Type->Object[Protocol,HPLC],
					Name->"Parent Protocol for ExperimentLyophilizeOptions testing " <> $SessionUUID
				|>
			}];

			UploadSample[{Model[Sample,"Milli-Q water"],Model[Sample,"Milli-Q water"]},{{"A1",vessel1},{"A1",vessel2}}];
		];

		immobileSetUp2 = Module[{modelVesselID,model,vessel1,vessel2},

			modelVesselID=CreateID[Model[Container,Vessel]];
			{model,vessel1,vessel2}=Upload[{
				<|
					Object->modelVesselID,
					Replace[Positions] ->{<|Name -> "A1", Footprint -> Null,MaxWidth -> .1 Meter,MaxDepth -> .1 Meter,MaxHeight -> .1 Meter|>},
					Immobile->True
				|>,
				<|
					Type->Object[Container,Vessel],
					Model->Link[modelVesselID,Objects],
					DeveloperObject->True,
					Site->Link[$Site],
					Name->"ExperimentLyophilizeOptions Immobile Container 2 " <> $SessionUUID,
					TareWeight->10 Gram
				|>,
				<|
					Type->Object[Container,Vessel],
					Model->Link[Model[Container,Vessel,"2mL Tube"],Objects],
					DeveloperObject->True,
					Site->Link[$Site],
					Name->"ExperimentLyophilizeOptions Non Immobile Container 2 " <> $SessionUUID,
					TareWeight->10 Gram
				|>
			}];

			UploadSample[{Model[Sample,"Milli-Q water"],Model[Sample,"Milli-Q water"]},{{"A1",vessel1},{"A1",vessel2}}];
		];
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
(*ValidExperimentLyophilizeQ*)


DefineTests[
	ValidExperimentLyophilizeQ,
	{
		Example[{Basic,"Verify that the experiment can be run without issue:"},
			ValidExperimentLyophilizeQ[{Object[Sample,"ValidExperimentLyophilizeQ Test Water Sample " <> $SessionUUID],Object[Sample,"ValidExperimentLyophilizeQ Test Water Sample2 " <> $SessionUUID]}],
			True
		],
		Example[{Basic,"Return False if there are problems with the inputs or options:"},
			ValidExperimentLyophilizeQ[{Object[Sample,"ValidExperimentLyophilizeQ Test Water Sample " <> $SessionUUID],Object[Sample,"ValidExperimentLyophilizeQ Test Water Sample2 " <> $SessionUUID]},
				EvaporationTemperature -> 95*Celsius,
				EvaporationType->SpeedVac
			],
			False
		],
		Example[{Options,OutputFormat,"Return a test summary:"},
			ValidExperimentLyophilizeQ[Object[Sample,"ValidExperimentLyophilizeQ Test Water Sample " <> $SessionUUID],OutputFormat->TestSummary],
			_EmeraldTestSummary
		],
		Example[{Options,Verbose,"Print verbose messages reporting test passage/failure:"},
			ValidExperimentLyophilizeQ[Object[Sample,"ValidExperimentLyophilizeQ Test Water Sample " <> $SessionUUID],Verbose->True],
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
				Object[Container,Plate,"ValidExperimentLyophilizeQ Test Plate " <> $SessionUUID],
				Object[Container,Vessel,"ValidExperimentLyophilizeQ Immobile Container " <> $SessionUUID],
				Object[Container,Vessel,"ValidExperimentLyophilizeQ Non Immobile Container " <> $SessionUUID],
				Object[Container,Vessel,"ValidExperimentLyophilizeQ Non Immobile Container 2 " <> $SessionUUID],
				Object[Container,Vessel,"ValidExperimentLyophilizeQ Immobile Container 2 " <> $SessionUUID],
				Object[Container,Vessel,"ValidExperimentLyophilizeQ Test 50mL 1 " <> $SessionUUID],
				Object[Container,Vessel,"ValidExperimentLyophilizeQ Test 50mL 2 " <> $SessionUUID],
				Object[Sample,"ValidExperimentLyophilizeQ Test Water Sample " <> $SessionUUID],
				Object[Sample,"ValidExperimentLyophilizeQ Test Water Sample2 " <> $SessionUUID],
				Object[Sample,"ValidExperimentLyophilizeQ Test Water Sample3 " <> $SessionUUID],
				Object[Sample,"ValidExperimentLyophilizeQ Test Water Sample4 " <> $SessionUUID],
				Object[Sample,"ValidExperimentLyophilizeQ Test Water Sample5 " <> $SessionUUID],
				Object[Sample,"ValidExperimentLyophilizeQ Test DCM Sample " <> $SessionUUID],
				Object[Sample,"ValidExperimentLyophilizeQ Test DCM Sample2 " <> $SessionUUID],
				Object[Protocol,HPLC,"Parent Protocol for ValidExperimentLyophilizeQ testing " <> $SessionUUID]
			};

			EraseObject[
				PickList[namedObjects,DatabaseMemberQ[namedObjects]],
				Force->True,
				Verbose->False
			]
		];

		(* Create an ID for the Model[Container,Vessel] we're gonna make below*)
		fakeNewModelID = CreateID[Model[Container,Vessel]];

		(* Create some containers *)
		{
			testPlate,
			fiftyMLtube1,
			fiftyMLtube2
		} = Upload[{
			<|Type->Object[Container,Plate],Model->Link[Model[Container,Plate,"96-well 2mL Deep Well Plate"],Objects],Name->"ValidExperimentLyophilizeQ Test Plate " <> $SessionUUID,Site->Link[$Site],DeveloperObject->True|>,
			<|Type->Object[Container,Vessel],Model->Link[Model[Container,Vessel,"id:bq9LA0dBGGR6"],Objects],Name->"ValidExperimentLyophilizeQ Test 50mL 1 " <> $SessionUUID,Site->Link[$Site],DeveloperObject->True|>,
			<|Type->Object[Container,Vessel],Model->Link[Model[Container,Vessel,"id:bq9LA0dBGGR6"],Objects],Name->"ValidExperimentLyophilizeQ Test 50mL 2 " <> $SessionUUID,Site->Link[$Site],DeveloperObject->True|>
		}];

		(* Create some samples *)
		{
			waterSample,
			waterSample2,
			waterSample3,
			waterSample4,
			waterSample5,
			dcmSamp1,
			dcmSamp2
		} = ECL`InternalUpload`UploadSample[
			{
				Model[Sample,"Milli-Q water"],
				Model[Sample,"Milli-Q water"],
				Model[Sample,"Milli-Q water"],
				Model[Sample,"Milli-Q water"],
				Model[Sample,"Milli-Q water"],
				Model[Sample,"Dichloromethane, Anhydrous"],
				Model[Sample,"Dichloromethane, Anhydrous"]
			},
			{
				{"A1",testPlate},
				{"A2",testPlate},
				{"A3",testPlate},
				{"B1",testPlate},
				{"B2",testPlate},
				{"A1",fiftyMLtube1},
				{"A1",fiftyMLtube2}
			},
			InitialAmount->{
				10 Microliter,
				100 Microliter,
				1 Milliliter,
				1.9 Milliliter,
				1.5 Milliliter,
				30 Milliliter,
				45 Milliliter
			},
			StorageCondition -> AmbientStorage
		];

		(* Secondary uploads *)
		Upload[{
			<|Object->waterSample,Name->"ValidExperimentLyophilizeQ Test Water Sample " <> $SessionUUID,Status->Available,DeveloperObject->True,ExpirationDate->Now + Year|>,
			<|Object->waterSample2,Name->"ValidExperimentLyophilizeQ Test Water Sample2 " <> $SessionUUID,Status->Available,DeveloperObject->True,ExpirationDate->Now + Year|>,
			<|Object->waterSample3,Name->"ValidExperimentLyophilizeQ Test Water Sample3 " <> $SessionUUID,Status->Available,DeveloperObject->True,ExpirationDate->Now + Year|>,
			<|Object->waterSample4,Name->"ValidExperimentLyophilizeQ Test Water Sample4 " <> $SessionUUID,Status->Available,DeveloperObject->True,ExpirationDate->Now + Year|>,
			<|Object->waterSample5,Name->"ValidExperimentLyophilizeQ Test Water Sample5 " <> $SessionUUID,Status->Available,DeveloperObject->True,ExpirationDate->Now + Year|>,
			<|Object->dcmSamp1,Name->"ValidExperimentLyophilizeQ Test DCM Sample " <> $SessionUUID,Status->Available,DeveloperObject->True|>,
			<|Object->dcmSamp2,Name->"ValidExperimentLyophilizeQ Test DCM Sample2 " <> $SessionUUID,Status->Available,DeveloperObject->True|>
		}];

		(* Upload 50 2ml tubes for batching checks *)
		myMV2mLSet = ConstantArray[
			<|Type->Object[Container,Vessel],Model->Link[Model[Container,Vessel,"2mL Tube"],Objects],Site->Link[$Site],DeveloperObject->True|>,
			50
		];

		myMV2mLTubes = Upload[myMV2mLSet];

		UploadSample[
			ConstantArray[Model[Sample,"Milli-Q water"],Length[myMV2mLTubes]],
			{"A1",#}&/@myMV2mLTubes,
			InitialAmount -> ConstantArray[300*Microliter,Length[myMV2mLTubes]],
			StorageCondition -> Refrigerator
		];

		immobileSetUp = Module[{modelVesselID,model,vessel1,vessel2,protocol},

			modelVesselID=CreateID[Model[Container,Vessel]];
			{model,vessel1,vessel2,protocol}=Upload[{
				<|
					Object->modelVesselID,
					Replace[Positions] ->{<|Name -> "A1", Footprint -> Null,MaxWidth -> .1 Meter,MaxDepth -> .1 Meter,MaxHeight -> .1 Meter|>},
					Immobile->True
				|>,
				<|
					Type->Object[Container,Vessel],
					Model->Link[modelVesselID,Objects],
					DeveloperObject->True,
					Name->"ValidExperimentLyophilizeQ Immobile Container " <> $SessionUUID,
					Site->Link[$Site]
				|>,
				<|
					Type->Object[Container,Vessel],
					Model->Link[Model[Container,Vessel,"2mL Tube"],Objects],
					DeveloperObject->True,
					Name->"ValidExperimentLyophilizeQ Non Immobile Container " <> $SessionUUID,
					Site->Link[$Site]
				|>,
				<|
					Type->Object[Protocol,HPLC],
					Name->"Parent Protocol for ValidExperimentLyophilizeQ testing " <> $SessionUUID
				|>
			}];

			UploadSample[{Model[Sample,"Milli-Q water"],Model[Sample,"Milli-Q water"]},{{"A1",vessel1},{"A1",vessel2}}];
		];

		immobileSetUp2 = Module[{modelVesselID,model,vessel1,vessel2},

			modelVesselID=CreateID[Model[Container,Vessel]];
			{model,vessel1,vessel2}=Upload[{
				<|
					Object->modelVesselID,
					Replace[Positions] ->{<|Name -> "A1", Footprint -> Null,MaxWidth -> .1 Meter,MaxDepth -> .1 Meter,MaxHeight -> .1 Meter|>},
					Immobile->True
				|>,
				<|
					Type->Object[Container,Vessel],
					Model->Link[modelVesselID,Objects],
					DeveloperObject->True,
					Name->"ValidExperimentLyophilizeQ Immobile Container 2 " <> $SessionUUID,
					TareWeight->10 Gram,
					Site->Link[$Site]
				|>,
				<|
					Type->Object[Container,Vessel],
					Model->Link[Model[Container,Vessel,"2mL Tube"],Objects],
					DeveloperObject->True,
					Name->"ValidExperimentLyophilizeQ Non Immobile Container 2 " <> $SessionUUID,
					TareWeight->10 Gram,
					Site->Link[$Site]
				|>
			}];

			UploadSample[{Model[Sample,"Milli-Q water"],Model[Sample,"Milli-Q water"]},{{"A1",vessel1},{"A1",vessel2}}];
		];
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
