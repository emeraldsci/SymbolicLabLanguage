
(* ::Subsection::Closed:: *)
(*ExperimentNephelometryOptions*)


DefineTests[ExperimentNephelometryOptions,
	{
		Example[{Basic,"Returns the options in table form given a sample:"},
			ExperimentNephelometryOptions[
				Object[Sample,"ExperimentNephelometryOptions test sample 1"],
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
			ExperimentNephelometryOptions[
				Object[Sample,"ExperimentNephelometryOptions test sample 1"],
				OutputFormat->List,
				BlankMeasurement->False
			],
			{_Rule..},
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			)
		],
		Example[{Basic, "View any potential issues with provided inputs/options displayed:"},
			ExperimentNephelometryOptions[
				Object[Sample,"ExperimentNephelometryOptions test sample 1"],
				PreparedPlate -> True,
				MoatSize->1,
				BlankMeasurement->False
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
				Object[Container, Bench, "Fake bench for ExperimentNephelometryOptions tests"],
				Object[Container,Plate,"ExperimentNephelometryOptions test plate 1"],
				Model[Molecule,Oligomer,"ExperimentNephelometryOptions test DNA molecule"],
				Model[Sample,"ExperimentNephelometryOptions test DNA sample"],
				Object[Sample,"ExperimentNephelometryOptions test sample 1"],
				Object[Sample,"ExperimentNephelometryOptions test sample 2"]

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
					Name -> "Fake bench for ExperimentNephelometryOptions tests",
					DeveloperObject -> True,
					StorageCondition -> Link[Model[StorageCondition, "Ambient Storage"]]
				|>];

				(*Make some empty test container objects*)
				emptyTestContainers=UploadSample[
					{Model[Container, Plate, "96-well UV-Star Plate"]},
					{{"Work Surface", fakeBench}},
					Status -> {Available},
					Name -> {"ExperimentNephelometryOptions test plate 1"}
				];

				(*Make a test DNA identity model*)
				testOligomer=UploadOligomer["ExperimentNephelometryOptions test DNA molecule",Molecule->Strand[RandomSequence[100]],PolymerType->DNA];

				(*Make some test sample models*)
				testSampleModels=UploadSampleModel[
					{
						"ExperimentNephelometryOptions test DNA sample"
					},
					Composition->
						{
							{{10 Micromolar,Model[Molecule,Oligomer,"ExperimentNephelometryOptions test DNA molecule"]},{100 VolumePercent,Model[Molecule,"Water"]}}
						},
					IncompatibleMaterials->ConstantArray[{None},1],
					Expires->ConstantArray[True,1],
					ShelfLife->ConstantArray[2 Year,1],
					UnsealedShelfLife->ConstantArray[90 Day,1],
					DefaultStorageCondition->ConstantArray[Model[StorageCondition,"Ambient Storage"],1],
					MSDSFile->ConstantArray[NotApplicable,1],
					BiosafetyLevel->ConstantArray["BSL-1",1],
					State->ConstantArray[Liquid,1]
				];

				(*Make some test sample objects in the test container objects*)
				testSampleContainerObjects=UploadSample[
					Join[
						ConstantArray[Model[Sample,"ExperimentNephelometryOptions test DNA sample"],2]
					],
					{
						{"A1",Object[Container,Plate,"ExperimentNephelometryOptions test plate 1"]},
						{"A2",Object[Container,Plate,"ExperimentNephelometryOptions test plate 1"]}
					},
					Name->
						{
							"ExperimentNephelometryOptions test sample 1",
							"ExperimentNephelometryOptions test sample 2"
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
				Object[Container, Bench, "Fake bench for ExperimentNephelometryOptions tests"],
				Object[Container,Plate,"ExperimentNephelometryOptions test plate 1"],
				Model[Molecule,Oligomer,"ExperimentNephelometryOptions test DNA molecule"],
				Model[Sample,"ExperimentNephelometryOptions test DNA sample"],
				Object[Sample,"ExperimentNephelometryOptions test sample 1"],
				Object[Sample,"ExperimentNephelometryOptions test sample 2"]

			}],ObjectP[]];

			(*Check whether the created objects and models exist in the database*)
			existingObjects=PickList[allObjects,DatabaseMemberQ[allObjects]];

			(*Erase all the created objects and models*)
			Quiet[EraseObject[existingObjects,Force->True,Verbose->False]]
		];
	)
];

(* ::Subsection::Closed:: *)
(*ExperimentNephelometryPreview*)

DefineTests[ExperimentNephelometryPreview,
	{
		Example[{Basic,"No preview is currently available for ExperimentNephelometry:"},
			ExperimentNephelometryPreview[
				Object[Sample,"ExperimentNephelometryPreview test sample 1"],
				BlankMeasurement->False
			],
			Null,
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			)
		],
		Example[{Additional, "If you wish to understand how the experiment will be performed, try using ExperimentNephelometryOptions:"},
			ExperimentNephelometryOptions[
				Object[Sample,"ExperimentNephelometryPreview test sample 1"],
				BlankMeasurement->False
			],
			_Grid,
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			)
		],
		Example[{Additional, "The inputs and options can also be checked to verify that the experiment can be safely run using ValidExperimentNephelometryQ:"},
			ValidExperimentNephelometryQ[
				Object[Sample,"ExperimentNephelometryPreview test sample 1"],
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
				Object[Container, Bench, "Fake bench for ExperimentNephelometryPreview tests"],
				Object[Container,Plate,"ExperimentNephelometryPreview test plate 1"],
				Model[Molecule,Oligomer,"ExperimentNephelometryPreview test DNA molecule"],
				Model[Sample,"ExperimentNephelometryPreview test DNA sample"],
				Object[Sample,"ExperimentNephelometryPreview test sample 1"],
				Object[Sample,"ExperimentNephelometryPreview test sample 2"]

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
					Name -> "Fake bench for ExperimentNephelometryPreview tests",
					DeveloperObject -> True,
					StorageCondition -> Link[Model[StorageCondition, "Ambient Storage"]]
				|>];

				(*Make some empty test container objects*)
				emptyTestContainers=UploadSample[
					{Model[Container, Plate, "96-well UV-Star Plate"]},
					{{"Work Surface", fakeBench}},
					Status -> {Available},
					Name -> {"ExperimentNephelometryPreview test plate 1"}
				];

				(*Make a test DNA identity model*)
				testOligomer=UploadOligomer["ExperimentNephelometryPreview test DNA molecule",Molecule->Strand[RandomSequence[100]],PolymerType->DNA];

				(*Make some test sample models*)
				testSampleModels=UploadSampleModel[
					{
						"ExperimentNephelometryPreview test DNA sample"
					},
					Composition->
						{
							{{10 Micromolar,Model[Molecule,Oligomer,"ExperimentNephelometryPreview test DNA molecule"]},{100 VolumePercent,Model[Molecule,"Water"]}}
						},
					IncompatibleMaterials->ConstantArray[{None},1],
					Expires->ConstantArray[True,1],
					ShelfLife->ConstantArray[2 Year,1],
					UnsealedShelfLife->ConstantArray[90 Day,1],
					DefaultStorageCondition->ConstantArray[Model[StorageCondition,"Ambient Storage"],1],
					MSDSFile->ConstantArray[NotApplicable,1],
					BiosafetyLevel->ConstantArray["BSL-1",1],
					State->ConstantArray[Liquid,1]
				];

				(*Make some test sample objects in the test container objects*)
				testSampleContainerObjects=UploadSample[
					Join[
						ConstantArray[Model[Sample,"ExperimentNephelometryPreview test DNA sample"],2]
					],
					{
						{"A1",Object[Container,Plate,"ExperimentNephelometryPreview test plate 1"]},
						{"A2",Object[Container,Plate,"ExperimentNephelometryPreview test plate 1"]}
					},
					Name->
						{
							"ExperimentNephelometryPreview test sample 1",
							"ExperimentNephelometryPreview test sample 2"
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
				Object[Container, Bench, "Fake bench for ExperimentNephelometryPreview tests"],
				Object[Container,Plate,"ExperimentNephelometryPreview test plate 1"],
				Model[Molecule,Oligomer,"ExperimentNephelometryPreview test DNA molecule"],
				Model[Sample,"ExperimentNephelometryPreview test DNA sample"],
				Object[Sample,"ExperimentNephelometryPreview test sample 1"],
				Object[Sample,"ExperimentNephelometryPreview test sample 2"]

			}],ObjectP[]];

			(*Check whether the created objects and models exist in the database*)
			existingObjects=PickList[allObjects,DatabaseMemberQ[allObjects]];

			(*Erase all the created objects and models*)
			Quiet[EraseObject[existingObjects,Force->True,Verbose->False]]
		];
	)
];


(* ::Subsection::Closed:: *)
(*ValidExperimentNephelometryQ*)


DefineTests[ValidExperimentNephelometryQ,
	{
		Example[{Basic,"Returns a Boolean indicating the validity of an ExperimentNephelometry experimental setup on a sample:"},
			ValidExperimentNephelometryQ[
				Object[Sample,"ValidExperimentNephelometryQ test sample 1"],
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
			ValidExperimentNephelometryQ[
				Object[Sample,"ValidExperimentNephelometryQ test sample 1"],
				PreparedPlate -> True,
				MoatSize->1,
				BlankMeasurement->False
			],
			False,
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			)
		],
		Example[{Options,Verbose,"If Verbose -> True, returns the passing and failing tests:"},
			ValidExperimentNephelometryQ[
				Object[Sample,"ValidExperimentNephelometryQ test sample 1"],
				Verbose->True,
				BlankMeasurement->False
			],
			True,
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			)
		],
		Example[{Options,OutputFormat,"If OutputFormat -> TestSummary, returns a test summary instead of a Boolean:"},
			ValidExperimentNephelometryQ[
				Object[Sample,"ValidExperimentNephelometryQ test sample 1"],
				OutputFormat->TestSummary,
				BlankMeasurement->False
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
				Object[Container, Bench, "Fake bench for ValidExperimentNephelometryQ tests"],
				Object[Container,Plate,"ValidExperimentNephelometryQ test plate 1"],
				Model[Molecule,Oligomer,"ValidExperimentNephelometryQ test DNA molecule"],
				Model[Sample,"ValidExperimentNephelometryQ test DNA sample"],
				Object[Sample,"ValidExperimentNephelometryQ test sample 1"],
				Object[Sample,"ValidExperimentNephelometryQ test sample 2"]

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
					Name -> "Fake bench for ValidExperimentNephelometryQ tests",
					DeveloperObject -> True,
					StorageCondition -> Link[Model[StorageCondition, "Ambient Storage"]]
				|>];

				(*Make some empty test container objects*)
				emptyTestContainers=UploadSample[
					{Model[Container, Plate, "96-well UV-Star Plate"]},
					{{"Work Surface", fakeBench}},
					Status -> {Available},
					Name -> {"ValidExperimentNephelometryQ test plate 1"}
				];

				(*Make a test DNA identity model*)
				testOligomer=UploadOligomer["ValidExperimentNephelometryQ test DNA molecule",Molecule->Strand[RandomSequence[100]],PolymerType->DNA];

				(*Make some test sample models*)
				testSampleModels=UploadSampleModel[
					{
						"ValidExperimentNephelometryQ test DNA sample"
					},
					Composition->
						{
							{{10 Micromolar,Model[Molecule,Oligomer,"ValidExperimentNephelometryQ test DNA molecule"]},{100 VolumePercent,Model[Molecule,"Water"]}}
						},
					IncompatibleMaterials->ConstantArray[{None},1],
					Expires->ConstantArray[True,1],
					ShelfLife->ConstantArray[2 Year,1],
					UnsealedShelfLife->ConstantArray[90 Day,1],
					DefaultStorageCondition->ConstantArray[Model[StorageCondition,"Ambient Storage"],1],
					MSDSFile->ConstantArray[NotApplicable,1],
					BiosafetyLevel->ConstantArray["BSL-1",1],
					State->ConstantArray[Liquid,1]
				];

				(*Make some test sample objects in the test container objects*)
				testSampleContainerObjects=UploadSample[
					Join[
						ConstantArray[Model[Sample,"ValidExperimentNephelometryQ test DNA sample"],2]
					],
					{
						{"A1",Object[Container,Plate,"ValidExperimentNephelometryQ test plate 1"]},
						{"A2",Object[Container,Plate,"ValidExperimentNephelometryQ test plate 1"]}
					},
					Name->
						{
							"ValidExperimentNephelometryQ test sample 1",
							"ValidExperimentNephelometryQ test sample 2"
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
				Object[Container, Bench, "Fake bench for ValidExperimentNephelometryQ tests"],
				Object[Container,Plate,"ValidExperimentNephelometryQ test plate 1"],
				Model[Molecule,Oligomer,"ValidExperimentNephelometryQ test DNA molecule"],
				Model[Sample,"ValidExperimentNephelometryQ test DNA sample"],
				Object[Sample,"ValidExperimentNephelometryQ test sample 1"],
				Object[Sample,"ValidExperimentNephelometryQ test sample 2"]

			}],ObjectP[]];

			(*Check whether the created objects and models exist in the database*)
			existingObjects=PickList[allObjects,DatabaseMemberQ[allObjects]];

			(*Erase all the created objects and models*)
			Quiet[EraseObject[existingObjects,Force->True,Verbose->False]]
		];
	)
];