
(* ::Subsection::Closed:: *)
(*ExperimentNephelometryKineticsOptions*)


DefineTests[ExperimentNephelometryKineticsOptions,
	{
		Example[{Basic,"Returns the options in table form given a sample:"},
			ExperimentNephelometryKineticsOptions[
				Object[Sample,"ExperimentNephelometryKineticsOptions test sample 1"],
				BlankMeasurement->False
			],
			_Grid,
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			)
		],
		Example[{Options,OutputFormat,"If OutputFormat -> List, returns the options as a list of rules:"},
			ExperimentNephelometryKineticsOptions[
				Object[Sample,"ExperimentNephelometryKineticsOptions test sample 1"],
				BlankMeasurement->False,
				OutputFormat->List
			],
			{_Rule..},
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			)
		],
		Example[{Basic, "View any potential issues with provided inputs/options displayed:"},
			ExperimentNephelometryKineticsOptions[
				Object[Sample,"ExperimentNephelometryKineticsOptions test sample 1"],
				PreparedPlate -> True,
				BlankMeasurement->False,
				MoatSize->1
			],
			_Grid,
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			),
			Messages :> {Error::NephelometryPreparedPlateInvalidOptions, Error::InvalidOption}
		]
	},


	Stubs:>{
		$PersonID=Object[User,"Test user for notebook-less test protocols"],
		$EmailEnabled=False
	},


	SymbolSetUp:>(
		Module[{allObjects,existingObjects},
			ClearMemoization[];

			Off[Warning::SamplesOutOfStock];
			Off[Warning::InstrumentUndergoingMaintenance];

			(*Gather all the objects and models created in SymbolSetUp*)
			allObjects=Cases[Flatten[{
				Object[Container, Bench, "Fake bench for ExperimentNephelometryKineticsOptions tests"],
				Object[Container,Plate,"ExperimentNephelometryKineticsOptions test plate 1"],
				Model[Molecule,Oligomer,"ExperimentNephelometryKineticsOptions test DNA molecule"],
				Model[Sample,"ExperimentNephelometryKineticsOptions test DNA sample"],
				Object[Sample,"ExperimentNephelometryKineticsOptions test sample 1"],
				Object[Sample,"ExperimentNephelometryKineticsOptions test sample 2"]

			}],ObjectP[]];

			(*Check whether the names we want to give below already exist in the database*)
			existingObjects=PickList[allObjects,DatabaseMemberQ[allObjects]];

			(*Erase any test objects and models that we failed to erase in the last unit test*)
			Quiet[EraseObject[existingObjects,Force->True,Verbose->False]]
		];


		Block[{$AllowSystemsProtocols=True},
			Module[{fakeBench, emptyTestContainers,testOligomer, testSampleModels,testSampleContainerObjects,
				containerSampleObjects,developerObjects,allObjects},

				(* set up fake bench as a location for the vessel *)
				fakeBench = Upload[<|
					Type -> Object[Container, Bench],
					Model -> Link[Model[Container, Bench, "The Bench of Testing"], Objects],
					Name -> "Fake bench for ExperimentNephelometryKineticsOptions tests",
					DeveloperObject -> True,
					StorageCondition -> Link[Model[StorageCondition, "Ambient Storage"]]
				|>];

				(*Make some empty test container objects*)
				emptyTestContainers=UploadSample[
					{Model[Container, Plate, "96-well UV-Star Plate"]},
					{{"Work Surface", fakeBench}},
					Status -> {Available},
					Name -> {"ExperimentNephelometryKineticsOptions test plate 1"}
				];

				(*Make a test DNA identity model*)
				testOligomer=UploadOligomer["ExperimentNephelometryKineticsOptions test DNA molecule",Molecule->Strand[RandomSequence[100]],PolymerType->DNA];

				(*Make some test sample models*)
				testSampleModels=UploadSampleModel[
					{
						"ExperimentNephelometryKineticsOptions test DNA sample"
					},
					Composition->
						{
							{{10 Micromolar,Model[Molecule,Oligomer,"ExperimentNephelometryKineticsOptions test DNA molecule"]},{100 VolumePercent,Model[Molecule,"Water"]}}
						},
					IncompatibleMaterials->ConstantArray[{None},1],
					Expires->ConstantArray[True,1],
					ShelfLife->ConstantArray[2 Year,1],
					UnsealedShelfLife->ConstantArray[90 Day,1],
					DefaultStorageCondition->ConstantArray[Model[StorageCondition,"Ambient Storage"],1],
					MSDSRequired->ConstantArray[False,1],
					BiosafetyLevel->ConstantArray["BSL-1",1],
					State->ConstantArray[Liquid,1]
				];

				(*Make some test sample objects in the test container objects*)
				testSampleContainerObjects=UploadSample[
					Join[
						ConstantArray[Model[Sample,"ExperimentNephelometryKineticsOptions test DNA sample"],2]
					],
					{
						{"A1",Object[Container,Plate,"ExperimentNephelometryKineticsOptions test plate 1"]},
						{"A2",Object[Container,Plate,"ExperimentNephelometryKineticsOptions test plate 1"]}
					},
					Name->
						{
							"ExperimentNephelometryKineticsOptions test sample 1",
							"ExperimentNephelometryKineticsOptions test sample 2"
						},
					InitialAmount->ConstantArray[0.5 Milliliter, 2]
				];

				(*Gather all the created objects and models*)
				containerSampleObjects={emptyTestContainers,testOligomer,testSampleModels,testSampleContainerObjects};

				(*Make all the test objects and models except the instrument parts developer objects*)
				developerObjects=Upload[<|Object->#,DeveloperObject->True|>&/@Flatten[containerSampleObjects]];

				(*Gather all the test objects and models created in SymbolSetUp*)
				allObjects=Flatten[{fakeBench,developerObjects}];

			]
		]
	),


	SymbolTearDown:>(
		Module[{allObjects,existingObjects},
			On[Warning::SamplesOutOfStock];
			On[Warning::InstrumentUndergoingMaintenance];

			(*Gather all the objects and models created in SymbolSetUp*)
			allObjects=Cases[Flatten[{
				Object[Container, Bench, "Fake bench for ExperimentNephelometryKineticsOptions tests"],
				Object[Container,Plate,"ExperimentNephelometryKineticsOptions test plate 1"],
				Model[Molecule,Oligomer,"ExperimentNephelometryKineticsOptions test DNA molecule"],
				Model[Sample,"ExperimentNephelometryKineticsOptions test DNA sample"],
				Object[Sample,"ExperimentNephelometryKineticsOptions test sample 1"],
				Object[Sample,"ExperimentNephelometryKineticsOptions test sample 2"]

			}],ObjectP[]];

			(*Check whether the created objects and models exist in the database*)
			existingObjects=PickList[allObjects,DatabaseMemberQ[allObjects]];

			(*Erase all the created objects and models*)
			Quiet[EraseObject[existingObjects,Force->True,Verbose->False]]
		];
	)
];

(* ::Subsection::Closed:: *)
(*ExperimentNephelometryKineticsPreview*)

DefineTests[ExperimentNephelometryKineticsPreview,
	{
		Example[{Basic,"No preview is currently available for ExperimentNephelometryKinetics:"},
			ExperimentNephelometryKineticsPreview[
				Object[Sample,"ExperimentNephelometryKineticsPreview test sample 1"],
				BlankMeasurement->False
			],
			Null,
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			)
		],
		Example[{Additional, "If you wish to understand how the experiment will be performed, try using ExperimentNephelometryKineticsOptions:"},
			ExperimentNephelometryKineticsOptions[
				Object[Sample,"ExperimentNephelometryKineticsPreview test sample 1"],
				BlankMeasurement->False
			],
			_Grid,
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			)
		],
		Example[{Additional, "The inputs and options can also be checked to verify that the experiment can be safely run using ValidExperimentNephelometryKineticsQ:"},
			ValidExperimentNephelometryKineticsQ[
				Object[Sample,"ExperimentNephelometryKineticsPreview test sample 1"],
				BlankMeasurement->False
			],
			True,
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			)
		]
	},


	Stubs:>{
		$PersonID=Object[User,"Test user for notebook-less test protocols"],
		$EmailEnabled=False
	},


	SymbolSetUp:>(
		Module[{allObjects,existingObjects},
			ClearMemoization[];

			Off[Warning::SamplesOutOfStock];
			Off[Warning::InstrumentUndergoingMaintenance];

			(*Gather all the objects and models created in SymbolSetUp*)
			allObjects=Cases[Flatten[{
				Object[Container, Bench, "Fake bench for ExperimentNephelometryKineticsPreview tests"],
				Object[Container,Plate,"ExperimentNephelometryKineticsPreview test plate 1"],
				Model[Molecule,Oligomer,"ExperimentNephelometryKineticsPreview test DNA molecule"],
				Model[Sample,"ExperimentNephelometryKineticsPreview test DNA sample"],
				Object[Sample,"ExperimentNephelometryKineticsPreview test sample 1"],
				Object[Sample,"ExperimentNephelometryKineticsPreview test sample 2"]

			}],ObjectP[]];

			(*Check whether the names we want to give below already exist in the database*)
			existingObjects=PickList[allObjects,DatabaseMemberQ[allObjects]];

			(*Erase any test objects and models that we failed to erase in the last unit test*)
			Quiet[EraseObject[existingObjects,Force->True,Verbose->False]]
		];


		Block[{$AllowSystemsProtocols=True},
			Module[{fakeBench, emptyTestContainers,testOligomer, testSampleModels,testSampleContainerObjects,
				containerSampleObjects,developerObjects,allObjects},

				(* set up fake bench as a location for the vessel *)
				fakeBench = Upload[<|
					Type -> Object[Container, Bench],
					Model -> Link[Model[Container, Bench, "The Bench of Testing"], Objects],
					Name -> "Fake bench for ExperimentNephelometryKineticsPreview tests",
					DeveloperObject -> True,
					StorageCondition -> Link[Model[StorageCondition, "Ambient Storage"]]
				|>];

				(*Make some empty test container objects*)
				emptyTestContainers=UploadSample[
					{Model[Container, Plate, "96-well UV-Star Plate"]},
					{{"Work Surface", fakeBench}},
					Status -> {Available},
					Name -> {"ExperimentNephelometryKineticsPreview test plate 1"}
				];

				(*Make a test DNA identity model*)
				testOligomer=UploadOligomer["ExperimentNephelometryKineticsPreview test DNA molecule",Molecule->Strand[RandomSequence[100]],PolymerType->DNA];

				(*Make some test sample models*)
				testSampleModels=UploadSampleModel[
					{
						"ExperimentNephelometryKineticsPreview test DNA sample"
					},
					Composition->
						{
							{{10 Micromolar,Model[Molecule,Oligomer,"ExperimentNephelometryKineticsPreview test DNA molecule"]},{100 VolumePercent,Model[Molecule,"Water"]}}
						},
					IncompatibleMaterials->ConstantArray[{None},1],
					Expires->ConstantArray[True,1],
					ShelfLife->ConstantArray[2 Year,1],
					UnsealedShelfLife->ConstantArray[90 Day,1],
					DefaultStorageCondition->ConstantArray[Model[StorageCondition,"Ambient Storage"],1],
					MSDSRequired->ConstantArray[False,1],
					BiosafetyLevel->ConstantArray["BSL-1",1],
					State->ConstantArray[Liquid,1]
				];

				(*Make some test sample objects in the test container objects*)
				testSampleContainerObjects=UploadSample[
					Join[
						ConstantArray[Model[Sample,"ExperimentNephelometryKineticsPreview test DNA sample"],2]
					],
					{
						{"A1",Object[Container,Plate,"ExperimentNephelometryKineticsPreview test plate 1"]},
						{"A2",Object[Container,Plate,"ExperimentNephelometryKineticsPreview test plate 1"]}
					},
					Name->
						{
							"ExperimentNephelometryKineticsPreview test sample 1",
							"ExperimentNephelometryKineticsPreview test sample 2"
						},
					InitialAmount->ConstantArray[0.5 Milliliter, 2]
				];

				(*Gather all the created objects and models*)
				containerSampleObjects={emptyTestContainers,testOligomer,testSampleModels,testSampleContainerObjects};

				(*Make all the test objects and models except the instrument parts developer objects*)
				developerObjects=Upload[<|Object->#,DeveloperObject->True|>&/@Flatten[containerSampleObjects]];

				(*Gather all the test objects and models created in SymbolSetUp*)
				allObjects=Flatten[{fakeBench,developerObjects}];

			]
		]
	),


	SymbolTearDown:>(
		Module[{allObjects,existingObjects},
			On[Warning::SamplesOutOfStock];
			On[Warning::InstrumentUndergoingMaintenance];

			(*Gather all the objects and models created in SymbolSetUp*)
			allObjects=Cases[Flatten[{
				Object[Container, Bench, "Fake bench for ExperimentNephelometryKineticsPreview tests"],
				Object[Container,Plate,"ExperimentNephelometryKineticsPreview test plate 1"],
				Model[Molecule,Oligomer,"ExperimentNephelometryKineticsPreview test DNA molecule"],
				Model[Sample,"ExperimentNephelometryKineticsPreview test DNA sample"],
				Object[Sample,"ExperimentNephelometryKineticsPreview test sample 1"],
				Object[Sample,"ExperimentNephelometryKineticsPreview test sample 2"]

			}],ObjectP[]];

			(*Check whether the created objects and models exist in the database*)
			existingObjects=PickList[allObjects,DatabaseMemberQ[allObjects]];

			(*Erase all the created objects and models*)
			Quiet[EraseObject[existingObjects,Force->True,Verbose->False]]
		];
	)
];


(* ::Subsection::Closed:: *)
(*ValidExperimentNephelometryKineticsQ*)


DefineTests[ValidExperimentNephelometryKineticsQ,
	{
		Example[{Basic,"Returns a Boolean indicating the validity of an ExperimentNephelometryKinetics experimental setup on a sample:"},
			ValidExperimentNephelometryKineticsQ[
				Object[Sample,"ValidExperimentNephelometryKineticsQ test sample 1"<>$SessionUUID],
				BlankMeasurement->False
			],
			True,
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			)
		],
		Example[{Basic, "Return False if there are problems with the inputs or options:"},
			ValidExperimentNephelometryKineticsQ[
				Object[Sample,"ValidExperimentNephelometryKineticsQ test sample 1"<>$SessionUUID],
				PreparedPlate -> True,
				MoatSize->1
			],
			False,
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			)
		],
		Example[{Options,Verbose,"If Verbose -> True, returns the passing and failing tests:"},
			ValidExperimentNephelometryKineticsQ[
				Object[Sample,"ValidExperimentNephelometryKineticsQ test sample 1"<>$SessionUUID],
				BlankMeasurement->False,
				Verbose->True
			],
			True,
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			)
		],
		Example[{Options,OutputFormat,"If OutputFormat -> TestSummary, returns a test summary instead of a Boolean:"},
			ValidExperimentNephelometryKineticsQ[
				Object[Sample,"ValidExperimentNephelometryKineticsQ test sample 1"<>$SessionUUID],
				BlankMeasurement->False,
				OutputFormat->TestSummary
			],
			_EmeraldTestSummary,
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			)
		]
	},



	Stubs:>{
		$PersonID=Object[User,"Test user for notebook-less test protocols"],
		$EmailEnabled=False
	},


	SymbolSetUp:>(
		Module[{allObjects,existingObjects},
			ClearMemoization[];

			Off[Warning::SamplesOutOfStock];
			Off[Warning::InstrumentUndergoingMaintenance];

			(*Gather all the objects and models created in SymbolSetUp*)
			allObjects=Cases[Flatten[{
				Object[Container, Bench, "Fake bench for ValidExperimentNephelometryKineticsQ tests"<>$SessionUUID],
				Object[Container,Plate,"ValidExperimentNephelometryKineticsQ test plate 1"<>$SessionUUID],
				Model[Molecule,Oligomer,"ValidExperimentNephelometryKineticsQ test DNA molecule"<>$SessionUUID],
				Model[Sample,"ValidExperimentNephelometryKineticsQ test DNA sample"<>$SessionUUID],
				Object[Sample,"ValidExperimentNephelometryKineticsQ test sample 1"<>$SessionUUID],
				Object[Sample,"ValidExperimentNephelometryKineticsQ test sample 2"<>$SessionUUID]

			}],ObjectP[]];

			(*Check whether the names we want to give below already exist in the database*)
			existingObjects=PickList[allObjects,DatabaseMemberQ[allObjects]];

			(*Erase any test objects and models that we failed to erase in the last unit test*)
			Quiet[EraseObject[existingObjects,Force->True,Verbose->False]]
		];


		Block[{$AllowSystemsProtocols=True},
			Module[{fakeBench, emptyTestContainers,testOligomer, testSampleModels,testSampleContainerObjects,
				containerSampleObjects,developerObjects,allObjects},

				(* set up fake bench as a location for the vessel *)
				fakeBench = Upload[<|
					Type -> Object[Container, Bench],
					Model -> Link[Model[Container, Bench, "The Bench of Testing"], Objects],
					Name -> "Fake bench for ValidExperimentNephelometryKineticsQ tests"<>$SessionUUID,
					DeveloperObject -> True,
					StorageCondition -> Link[Model[StorageCondition, "Ambient Storage"]]
				|>];

				(*Make some empty test container objects*)
				emptyTestContainers=UploadSample[
					{Model[Container, Plate, "96-well UV-Star Plate"]},
					{{"Work Surface", fakeBench}},
					Status -> {Available},
					Name -> {"ValidExperimentNephelometryKineticsQ test plate 1"<>$SessionUUID}
				];

				(*Make a test DNA identity model*)
				testOligomer=UploadOligomer["ValidExperimentNephelometryKineticsQ test DNA molecule"<>$SessionUUID,Molecule->Strand[RandomSequence[100]],PolymerType->DNA];

				(*Make some test sample models*)
				testSampleModels=UploadSampleModel[
					{
						"ValidExperimentNephelometryKineticsQ test DNA sample"<>$SessionUUID
					},
					Composition->
						{
							{{10 Micromolar,Model[Molecule,Oligomer,"ValidExperimentNephelometryKineticsQ test DNA molecule"<>$SessionUUID]},{100 VolumePercent,Model[Molecule,"Water"]}}
						},
					IncompatibleMaterials->ConstantArray[{None},1],
					Expires->ConstantArray[True,1],
					ShelfLife->ConstantArray[2 Year,1],
					UnsealedShelfLife->ConstantArray[90 Day,1],
					DefaultStorageCondition->ConstantArray[Model[StorageCondition,"Ambient Storage"],1],
					MSDSRequired->ConstantArray[False,1],
					BiosafetyLevel->ConstantArray["BSL-1",1],
					State->ConstantArray[Liquid,1]
				];

				(*Make some test sample objects in the test container objects*)
				testSampleContainerObjects=UploadSample[
					Join[
						ConstantArray[Model[Sample,"ValidExperimentNephelometryKineticsQ test DNA sample"<>$SessionUUID],2]
					],
					{
						{"A1",Object[Container,Plate,"ValidExperimentNephelometryKineticsQ test plate 1"<>$SessionUUID]},
						{"A2",Object[Container,Plate,"ValidExperimentNephelometryKineticsQ test plate 1"<>$SessionUUID]}
					},
					Name->
						{
							"ValidExperimentNephelometryKineticsQ test sample 1"<>$SessionUUID,
							"ValidExperimentNephelometryKineticsQ test sample 2"<>$SessionUUID
						},
					InitialAmount->ConstantArray[0.5 Milliliter, 2]
				];

				(*Gather all the created objects and models*)
				containerSampleObjects={emptyTestContainers,testOligomer,testSampleModels,testSampleContainerObjects};

				(*Make all the test objects and models except the instrument parts developer objects*)
				developerObjects=Upload[<|Object->#,DeveloperObject->True|>&/@Flatten[containerSampleObjects]];

				(*Gather all the test objects and models created in SymbolSetUp*)
				allObjects=Flatten[{fakeBench,developerObjects}];

			]
		]
	),


	SymbolTearDown:>(
		Module[{allObjects,existingObjects},
			On[Warning::SamplesOutOfStock];
			On[Warning::InstrumentUndergoingMaintenance];

			(*Gather all the objects and models created in SymbolSetUp*)
			allObjects=Cases[Flatten[{
				Object[Container, Bench, "Fake bench for ValidExperimentNephelometryKineticsQ tests"<>$SessionUUID],
				Object[Container,Plate,"ValidExperimentNephelometryKineticsQ test plate 1"<>$SessionUUID],
				Model[Molecule,Oligomer,"ValidExperimentNephelometryKineticsQ test DNA molecule"<>$SessionUUID],
				Model[Sample,"ValidExperimentNephelometryKineticsQ test DNA sample"<>$SessionUUID],
				Object[Sample,"ValidExperimentNephelometryKineticsQ test sample 1"<>$SessionUUID],
				Object[Sample,"ValidExperimentNephelometryKineticsQ test sample 2"<>$SessionUUID]

			}],ObjectP[]];

			(*Check whether the created objects and models exist in the database*)
			existingObjects=PickList[allObjects,DatabaseMemberQ[allObjects]];

			(*Erase all the created objects and models*)
			Quiet[EraseObject[existingObjects,Force->True,Verbose->False]]
		];
	)
];