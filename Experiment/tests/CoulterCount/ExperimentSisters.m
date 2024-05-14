(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*Unit Testing*)


(* ::Subsection:: *)
(*ExperimentCoulterCountPreview*)

DefineTests[
	ExperimentCoulterCountPreview,
	{
		Example[{Basic, "No preview is currently available for ExperimentCoulterCount:"},
			ExperimentCoulterCountPreview[
				{
					Object[Sample, "test sample 1 for ExperimentCoulterCountPreview unit test "<>$SessionUUID],
					Object[Container, Vessel, "test tube 2 for ExperimentCoulterCountPreview unit test "<>$SessionUUID]
				}
			],
			Null
		],
		Example[{Basic, "Any potential issues with provided inputs/options will be displayed:"},
			ExperimentCoulterCountPreview[Object[Sample, "test sample 3 for ExperimentCoulterCountPreview unit test "<>$SessionUUID]],
			Null,
			Messages :> {Error::ParticleSizeOutOfRange, Error::InvalidInput, Error::InvalidOption}
		],
		Example[{Additional, "If you wish to understand how the experiment will be performed try using ExperimentCoulterCountOptions:"},
			ExperimentCoulterCountOptions[
				{
					Object[Sample, "test sample 1 for ExperimentCoulterCountPreview unit test "<>$SessionUUID],
					Object[Container, Vessel, "test tube 2 for ExperimentCoulterCountPreview unit test "<>$SessionUUID]
				}
			],
			_Grid
		],
		Example[{Additional, "The inputs and options can also be checked to verify that the experiment can be safely run by using ValidExperimentCoulterCountQ:"},
			ValidExperimentCoulterCountQ[
				{
					Object[Sample, "test sample 1 for ExperimentCoulterCountPreview unit test "<>$SessionUUID],
					Object[Container, Vessel, "test tube 2 for ExperimentCoulterCountPreview unit test "<>$SessionUUID]
				}
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
		coulterCountSisterFunctionsTearDown[ExperimentCoulterCountPreview];
		$CreatedObjects = {};
		coulterCountSisterFunctionsSetUp[ExperimentCoulterCountPreview];
	),
	SymbolTearDown :> (
		coulterCountSisterFunctionsTearDown[ExperimentCoulterCountPreview];
	)
];


(* ::Subsection:: *)
(*ExperimentCoulterCountOptions*)



DefineTests[
	ExperimentCoulterCountOptions,
	{
		Example[{Basic, "Display the option values which will be used in the experiment:"},
			ExperimentCoulterCountOptions[
				{
					Object[Sample, "test sample 1 for ExperimentCoulterCountOptions unit test "<>$SessionUUID],
					Object[Container, Vessel, "test tube 2 for ExperimentCoulterCountOptions unit test "<>$SessionUUID]
				}
			],
			_Grid
		],
		Example[{Basic, "Any potential issues with provided inputs/options will be displayed:"},
			ExperimentCoulterCountOptions[Object[Sample, "test sample 3 for ExperimentCoulterCountOptions unit test "<>$SessionUUID]],
			_Grid,
			Messages :> {Error::ParticleSizeOutOfRange, Error::InvalidInput, Error::InvalidOption}
		],
		Example[{Options, OutputFormat, "If OutputFormat -> List, return a list of options:"},
			ExperimentCoulterCountOptions[
				{
					Object[Sample, "test sample 1 for ExperimentCoulterCountOptions unit test "<>$SessionUUID],
					Object[Container, Vessel, "test tube 2 for ExperimentCoulterCountOptions unit test "<>$SessionUUID]
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
		coulterCountSisterFunctionsTearDown[ExperimentCoulterCountOptions];
		$CreatedObjects = {};
		coulterCountSisterFunctionsSetUp[ExperimentCoulterCountOptions];
	),
	SymbolTearDown :> (
		coulterCountSisterFunctionsTearDown[ExperimentCoulterCountOptions];
	)
];


(* ::Subsection:: *)
(*ValidExperimentCoulterCountQ*)


DefineTests[
	ValidExperimentCoulterCountQ,
	{
		Example[{Basic, "Verify that the experiment can be run without issue:"},
			ValidExperimentCoulterCountQ[
				{
					Object[Sample, "test sample 1 for ValidExperimentCoulterCountQ unit test "<>$SessionUUID],
					Object[Container, Vessel, "test tube 2 for ValidExperimentCoulterCountQ unit test "<>$SessionUUID]
				}
			],
			True
		],
		Example[{Basic, "Return False if there are problems with the inputs or options:"},
			ValidExperimentCoulterCountQ[Object[Sample, "test sample 3 for ValidExperimentCoulterCountQ unit test "<>$SessionUUID]],
			False
		],
		Example[{Options, OutputFormat, "Return a test summary:"},
			ValidExperimentCoulterCountQ[
				{
					Object[Sample, "test sample 1 for ValidExperimentCoulterCountQ unit test "<>$SessionUUID],
					Object[Container, Vessel, "test tube 2 for ValidExperimentCoulterCountQ unit test "<>$SessionUUID]
				},
				OutputFormat -> TestSummary
			],
			_EmeraldTestSummary
		],
		Example[{Options, Verbose, "Print verbose messages reporting test passage/failure:"},
			ValidExperimentCoulterCountQ[Object[Sample, "test sample 3 for ValidExperimentCoulterCountQ unit test "<>$SessionUUID], Verbose -> Failures],
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
		coulterCountSisterFunctionsTearDown[ValidExperimentCoulterCountQ];
		$CreatedObjects = {};
		coulterCountSisterFunctionsSetUp[ValidExperimentCoulterCountQ];
	),
	SymbolTearDown :> (
		coulterCountSisterFunctionsTearDown[ValidExperimentCoulterCountQ];
	)
];


(* ::Subsection:: *)
(*SetUp and TearDown helpers*)


(* set up and tear down helper for all sister functions since they really can just use similar samples *)
coulterCountSisterFunctionsSetUp[head_Symbol] := Module[{headString, testBench, tube1, tube2, tube3, sample1, sample2, sample3},
	(* Convert the experiment head to string *)
	headString = ToString[head];

	(* Proceed to create objects *)
	Block[{$DeveloperUpload = True},
		(* Reserve id for a list of objects to create *)
		{
			testBench,
			tube1,
			tube2,
			tube3,
			sample1,
			sample2,
			sample3
		} = CreateID[{
			Object[Container, Bench],
			Object[Container, Vessel],
			Object[Container, Vessel],
			Object[Container, Vessel],
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
		{
			tube1,
			tube2,
			tube3
		} = UploadSample[
			{
				Model[Container, Vessel, "100 mL Glass Bottle"],
				Model[Container, Vessel, "100 mL Glass Bottle"],
				Model[Container, Vessel, "100 mL Glass Bottle"]
			},
			{
				{"Work Surface", testBench},
				{"Work Surface", testBench},
				{"Work Surface", testBench}
			},
			Name -> {
				"test tube 1 for "<>headString<>" unit test "<>$SessionUUID,
				"test tube 2 for "<>headString<>" unit test "<>$SessionUUID,
				"test tube 3 for "<>headString<>" unit test "<>$SessionUUID
			}
		];

		(* sample 1 and sample 2 are good samples, sample 3 will throw an error *)
		{
			sample1,
			sample2,
			sample3
		} = UploadSample[
			{
				{{10^4 / AvogadroConstant / Milliliter, Model[Molecule, Polymer, "id:o1k9jAGP8jJN"]}, {99 VolumePercent, Model[Molecule, "Water"]}},
				{{10^4 EmeraldCell / Milliliter, Model[Cell, Bacteria, "id:54n6evLm7m0L"]}, {99 VolumePercent, Model[Molecule, "Water"]}},
				{{10^4 / AvogadroConstant / Milliliter, Model[Molecule, Polymer, "id:o1k9jAGP8jJN"]}, {99 VolumePercent, Model[Molecule, "Water"]}}
			},
			{
				{"A1", tube1},
				{"A1", tube2},
				{"A1", tube3}
			},
			InitialAmount -> {
				75 Milliliter,
				75 Milliliter,
				75 Milliliter
			},
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
			State -> {
				Liquid,
				Liquid,
				Liquid
			},
			Living -> {
				Null,
				True,
				Null
			}
		];

		(* secondary upload to make sample 3 oversize *)
		Upload[{
			<|
				Object -> sample3,
				ParticleSize -> EmpiricalDistribution[{99, 1} -> {1700 * Micrometer, 100 Micrometer}]
			|>
		}]

	]
];

coulterCountSisterFunctionsTearDown[head_Symbol] := Module[{headString, objects, objectsExistQ},
	(* Convert the experiment head to string *)
	headString = ToString[head];
	(* List all test objects to erase. Can use SetUpTestObjects[]+ObjectToString[] to get the comprehensive list. *)
	objects = Flatten[{
		Object[Container, Bench, "test bench for "<>headString<>" unit test "<>$SessionUUID],
		Object[Container, Vessel, "test tube 1 for "<>headString<>" unit test "<>$SessionUUID],
		Object[Container, Vessel, "test tube 2 for "<>headString<>" unit test "<>$SessionUUID],
		Object[Container, Vessel, "test tube 3 for "<>headString<>" unit test "<>$SessionUUID],
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




