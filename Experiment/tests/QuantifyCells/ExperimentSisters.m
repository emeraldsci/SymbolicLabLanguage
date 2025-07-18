(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*Unit Testing*)


(* ::Subsection:: *)
(*ExperimentQuantifyCellsPreview*)

DefineTests[
	ExperimentQuantifyCellsPreview,
	{
		Example[{Basic, "No preview is currently available for ExperimentQuantifyCells:"},
			ExperimentQuantifyCellsPreview[
				Object[Container, Plate, "test plate 1 for ExperimentQuantifyCellsPreview unit test "<>$SessionUUID]
			],
			Null
		],
		Example[{Basic, "Any potential issues with provided inputs/options will be displayed:"},
			ExperimentQuantifyCellsPreview[Object[Container, Plate, "test plate 1 for ExperimentQuantifyCellsPreview unit test "<>$SessionUUID], Methods -> {Absorbance, Absorbance, Nephelometry}],
			Null,
			Messages :> {Error::DuplicatedMethods, Error::InvalidOption}
		],
		Example[{Additional, "If you wish to understand how the experiment will be performed try using ExperimentQuantifyCellsOptions:"},
			ExperimentQuantifyCellsOptions[
				{
					Object[Sample, "test sample 1 for ExperimentQuantifyCellsPreview unit test "<>$SessionUUID],
					Object[Sample, "test sample 2 for ExperimentQuantifyCellsPreview unit test "<>$SessionUUID]
				}
			],
			_Grid
		],
		Example[{Additional, "The inputs and options can also be checked to verify that the experiment can be safely run by using ValidExperimentQuantifyCellsQ:"},
			ValidExperimentQuantifyCellsQ[
				Object[Container, Plate, "test plate 1 for ExperimentQuantifyCellsPreview unit test "<>$SessionUUID]
			],
			True
		]
	},
	Stubs :> {
		(* I am an important stub that prevents the tester from getting a bunch of notifications *)
		$PersonID = Object[User, "Test user for notebook-less test protocols"]
	},
	SetUp :> {
		$CreatedObjects = {};
		ClearMemoization[];
		Off[Warning::SamplesOutOfStock];
		Off[Warning::DeprecatedProduct];
		Off[Warning::SampleMustBeMoved];
	},
	TearDown :> (
		EraseObject[$CreatedObjects, Force -> True];
		Unset[$CreatedObjects];
		On[Warning::SamplesOutOfStock];
		On[Warning::DeprecatedProduct];
		On[Warning::SampleMustBeMoved];
	),
	SymbolSetUp :> (
		QuantifyCellsSisterFunctionsTearDown[ExperimentQuantifyCellsPreview];
		$CreatedObjects = {};
		QuantifyCellsSisterFunctionsSetUp[ExperimentQuantifyCellsPreview];
	),
	SymbolTearDown :> (
		QuantifyCellsSisterFunctionsTearDown[ExperimentQuantifyCellsPreview];
	)
];


(* ::Subsection:: *)
(*ExperimentQuantifyCellsOptions*)



DefineTests[
	ExperimentQuantifyCellsOptions,
	{
		Example[{Basic, "Display the option values which will be used in the experiment:"},
			ExperimentQuantifyCellsOptions[
				Object[Container, Plate, "test plate 1 for ExperimentQuantifyCellsOptions unit test "<>$SessionUUID]
			],
			_Grid
		],
		Example[{Basic, "Any potential issues with provided inputs/options will be displayed:"},
			ExperimentQuantifyCellsOptions[Object[Container, Plate, "test plate 1 for ExperimentQuantifyCellsOptions unit test "<>$SessionUUID], Methods -> {Absorbance, Absorbance, Nephelometry}],
			_Grid,
			Messages :> {Error::DuplicatedMethods, Error::InvalidOption}
		],
		Example[{Options, OutputFormat, "If OutputFormat -> List, return a list of options:"},
			ExperimentQuantifyCellsOptions[
				{
					Object[Sample, "test sample 1 for ExperimentQuantifyCellsOptions unit test "<>$SessionUUID],
					Object[Sample, "test sample 2 for ExperimentQuantifyCellsOptions unit test "<>$SessionUUID]
				},
				OutputFormat -> List
			],
			{(_Rule | _RuleDelayed)..}
		]
	},
	Stubs :> {
		(* I am an important stub that prevents the tester from getting a bunch of notifications *)
		$PersonID = Object[User, "Test user for notebook-less test protocols"]
	},
	SetUp :> {
		$CreatedObjects = {};
		ClearMemoization[];
		Off[Warning::SamplesOutOfStock];
		Off[Warning::DeprecatedProduct];
		Off[Warning::SampleMustBeMoved];
	},
	TearDown :> (
		EraseObject[$CreatedObjects, Force -> True];
		Unset[$CreatedObjects];
		On[Warning::SamplesOutOfStock];
		On[Warning::DeprecatedProduct];
		On[Warning::SampleMustBeMoved];
	),
	SymbolSetUp :> (
		QuantifyCellsSisterFunctionsTearDown[ExperimentQuantifyCellsOptions];
		$CreatedObjects = {};
		QuantifyCellsSisterFunctionsSetUp[ExperimentQuantifyCellsOptions];
	),
	SymbolTearDown :> (
		QuantifyCellsSisterFunctionsTearDown[ExperimentQuantifyCellsOptions];
	)
];


(* ::Subsection:: *)
(*ValidExperimentQuantifyCellsQ*)


DefineTests[
	ValidExperimentQuantifyCellsQ,
	{
		Example[{Basic, "Verify that the experiment can be run without issue:"},
			ValidExperimentQuantifyCellsQ[
				Object[Container, Plate, "test plate 1 for ValidExperimentQuantifyCellsQ unit test "<>$SessionUUID]
			],
			True
		],
		Example[{Basic, "Return False if there are problems with the inputs or options:"},
			ValidExperimentQuantifyCellsQ[Object[Container, Plate, "test plate 1 for ValidExperimentQuantifyCellsQ unit test "<>$SessionUUID], Methods -> {Absorbance, Absorbance, Nephelometry}],
			False
		],
		Example[{Options, OutputFormat, "Return a test summary:"},
			ValidExperimentQuantifyCellsQ[
				{
					Object[Sample, "test sample 1 for ValidExperimentQuantifyCellsQ unit test "<>$SessionUUID],
					Object[Sample, "test sample 2 for ValidExperimentQuantifyCellsQ unit test "<>$SessionUUID]
				},
				OutputFormat -> TestSummary
			],
			_EmeraldTestSummary
		],
		Example[{Options, Verbose, "Print verbose messages reporting test passage/failure:"},
			ValidExperimentQuantifyCellsQ[Object[Container, Plate, "test plate 1 for ValidExperimentQuantifyCellsQ unit test "<>$SessionUUID], Methods -> {Absorbance, Absorbance, Nephelometry}, Verbose -> Failures],
			False
		]
	},
	Stubs :> {
		(* I am an important stub that prevents the tester from getting a bunch of notifications *)
		$PersonID = Object[User, "Test user for notebook-less test protocols"]
	},
	SetUp :> {
		$CreatedObjects = {};
		ClearMemoization[];
		Off[Warning::SamplesOutOfStock];
		Off[Warning::DeprecatedProduct];
		Off[Warning::SampleMustBeMoved];
	},
	TearDown :> (
		EraseObject[$CreatedObjects, Force -> True];
		Unset[$CreatedObjects];
		On[Warning::SamplesOutOfStock];
		On[Warning::DeprecatedProduct];
		On[Warning::SampleMustBeMoved];
	),
	SymbolSetUp :> (
		QuantifyCellsSisterFunctionsTearDown[ValidExperimentQuantifyCellsQ];
		$CreatedObjects = {};
		QuantifyCellsSisterFunctionsSetUp[ValidExperimentQuantifyCellsQ];
	),
	SymbolTearDown :> (
		QuantifyCellsSisterFunctionsTearDown[ValidExperimentQuantifyCellsQ];
	)
];


(* ::Subsection:: *)
(*SetUp and TearDown helpers*)


(* set up and tear down helper for all sister functions since they really can just use similar samples *)
QuantifyCellsSisterFunctionsSetUp[head_Symbol] := Module[{headString, testBench, plate1, plate2, sample1, sample2, sample3},
	(* Convert the experiment head to string *)
	headString = ToString[head];

	(* Proceed to create objects *)
	Block[{$DeveloperUpload = True},
		(* Reserve id for a list of objects to create *)
		{
			testBench,
			plate1,
			plate2,
			sample1,
			sample2,
			sample3
		} = CreateID[{
			Object[Container, Bench],
			Object[Container, Plate],
			Object[Container, Plate],
			Object[Sample],
			Object[Sample],
			Object[Sample]
		}];

		(* raw upload to create the bench *)
		Upload[{
			<|
				Object -> testBench,
				Model -> Link[Model[Container, Bench, "id:bq9LA0JlA7Ad"], Objects],
				Name -> "test bench for "<>headString<>" unit test "<>$SessionUUID,
				Site -> Link[$Site]
			|>
		}];

		(* Make containers *)
		UploadSample[
			{
				Model[Container, Plate, "id:n0k9mGzRaaBn"], (* Model[Container, Plate, "96-well UV-Star Plate"] *)
				Model[Container, Plate, "id:n0k9mGzRaaBn"] (* Model[Container, Plate, "96-well UV-Star Plate"] *)
			},
			{
				{"Work Surface", testBench},
				{"Work Surface", testBench}
			},
			Name -> {
				"test plate 1 for "<>headString<>" unit test "<>$SessionUUID,
				"test plate 2 for "<>headString<>" unit test "<>$SessionUUID
			},
			ID -> Download[{
				plate1,
				plate2
			}, ID]
		];

		(* sample 1 and sample 2 are good samples, sample 3 will throw an error *)
		UploadSample[
			{
				{{0.5 * OD600, Model[Cell, Bacteria, "id:54n6evLm7m0L"]}, {99 VolumePercent, Model[Molecule, "id:vXl9j57PmP5D"]}}, (* Model[Cell, Bacteria, "E.coli MG1655"], Model[Molecule, "Water"] *)
				{{10^4 EmeraldCell / Milliliter, Model[Cell, Bacteria, "id:54n6evLm7m0L"]}, {99 VolumePercent, Model[Molecule, "id:vXl9j57PmP5D"]}}, (* Model[Cell, Bacteria, "E.coli MG1655"], Model[Molecule, "Water"] *)
				Model[Sample, "id:8qZ1VWNmdLBD"] (* Model[Sample, "Milli-Q water"] *)
			},
			{
				{"A1", plate1},
				{"A2", plate1},
				{"A1", plate2}
			},
			InitialAmount -> 200 * Microliter,
			Name -> {
				"test sample 1 for "<>headString<>" unit test "<>$SessionUUID,
				"test sample 2 for "<>headString<>" unit test "<>$SessionUUID,
				"test sample 3 for "<>headString<>" unit test "<>$SessionUUID
			},
			ID -> Download[{
				sample1,
				sample2,
				sample3
			}, ID],
			State -> Liquid,
			Living -> {
				False,
				False,
				Null
			}
		];

		(* upload date stocked so container plate pass VOQ *)
		Upload[{
			<|Object -> plate1, DateStocked -> Now - 1 * Week, DateUnsealed -> Now - 5 * Day|>,
			<|Object -> plate2, DateStocked -> Now - 1 * Week, DateUnsealed -> Now - 5 * Day|>
		}]

	]
];

QuantifyCellsSisterFunctionsTearDown[head_Symbol] := Module[{headString, objects, objectsExistQ},
	(* Convert the experiment head to string *)
	headString = ToString[head];
	(* List all test objects to erase. Can use SetUpTestObjects[]+ObjectToString[] to get the comprehensive list. *)
	objects = Flatten[{
		Object[Container, Bench, "test bench for "<>headString<>" unit test "<>$SessionUUID],
		Object[Container, Plate, "test plate 1 for "<>headString<>" unit test "<>$SessionUUID],
		Object[Container, Plate, "test plate 2 for "<>headString<>" unit test "<>$SessionUUID],
		Object[Sample, "test sample 1 for "<>headString<>" unit test "<>$SessionUUID],
		Object[Sample, "test sample 2 for "<>headString<>" unit test "<>$SessionUUID],
		Object[Sample, "test sample 3 for "<>headString<>" unit test "<>$SessionUUID],
		If[MatchQ[$CreatedObjects, _List], $CreatedObjects, Nothing]
	}];

	(* Check whether the names we want to give below already exist in the database *)
	objectsExistQ = DatabaseMemberQ[objects];

	(* Erase any objects that we failed to erase in the last unit test. *)
	Quiet[EraseObject[PickList[objects, objectsExistQ], Force -> True, Verbose -> False]]
];




