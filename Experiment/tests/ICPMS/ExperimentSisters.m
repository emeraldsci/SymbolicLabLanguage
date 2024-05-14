(* ::Subsection:: *)
(*ExperimentICPMSPreview*)
DefineTests[ExperimentICPMSPreview,
	{
		Example[{Basic, "No preview is currently available for ExperimentICPMS:"},
			ExperimentICPMSPreview[
				Object[Sample, "Test sample 1 for ExperimentICPMSPreview"<>$SessionUUID]
			],
			Null
		],
		Example[{Basic, "If you wish to understand how the experiment will be performed try using ExperimentICPMSOptions:"},
			ExperimentICPMSOptions[
				Object[Sample, "Test sample 1 for ExperimentICPMSPreview"<>$SessionUUID]
			],
			_Grid
		],
		Example[{Basic, "The inputs and options can also be checked to verify that the experiment can be safely run:"},
			ValidExperimentICPMSQ[
				Object[Sample, "Test sample 1 for ExperimentICPMSPreview"<>$SessionUUID],
				StandardType -> External,
				Elements -> {Sodium, Calcium}
			],
			True
		]
	},
	Stubs :> {
		$PersonID=Object[User,"Test user for notebook-less test protocols"]
	},
	SymbolSetUp :> (
		$CreatedObjects = {};
		ClearMemoization[];
		Off[Warning::SamplesOutOfStock];
		Off[Warning::InstrumentUndergoingMaintenance];
		Module[{objects, existsFilter},
			(* list of test objests *)
			objects = {
				Object[Sample, "Test sample 1 for ExperimentICPMSPreview" <> $SessionUUID],
				Object[Container, Vessel, "Test container 1 for ExperimentICPMSPreview" <> $SessionUUID],
				Object[Container, Bench, "Test Bench for ExperimentICPMSPreview"<>$SessionUUID]
			};

			(* Check whether the names we want to give below already exist in the database *)
			existsFilter = DatabaseMemberQ[objects];

			(* Erase any objects that we failed to erase in the last unit test. *)
			Quiet[EraseObject[PickList[objects, existsFilter], Force -> True, Verbose -> False]];
		];
		Module[{testBench},
			testBench = Upload[<|
				Type -> Object[Container, Bench],
				Model -> Link[Model[Container,Bench,"The Bench of Testing"],Objects],
				Name -> "Test Bench for ExperimentICPMSPreview"<>$SessionUUID,
				DeveloperObject -> True,
				StorageCondition -> Link[Model[StorageCondition,"Ambient Storage"]],
				Site -> Link[$Site]
			|>];
			Block[{$DeveloperUpload=True},
				UploadSample[Model[Container, Vessel, "15mL Tube"],
					{"Bench Top Slot", testBench},
					Name -> "Test container 1 for ExperimentICPMSPreview" <> $SessionUUID
				]
			];
			Block[{$DeveloperUpload=True},
				UploadSample[
					Model[Sample, "Milli-Q water"],
					{"A1", Object[Container, Vessel, "Test container 1 for ExperimentICPMSPreview" <> $SessionUUID]},
					InitialAmount -> 3 Milliliter,
					Name -> "Test sample 1 for ExperimentICPMSPreview" <> $SessionUUID
				]
			]
		]
	),
	SymbolTearDown :> (
		EraseObject[$CreatedObjects, Force -> True];
		Unset[$CreatedObjects];
		ClearMemoization[];
		On[Warning::SamplesOutOfStock];
		On[Warning::InstrumentUndergoingMaintenance];
		Module[{objects, existsFilter},
			(* list of test objests *)
			objects = {
				Object[Sample, "Test sample 1 for ExperimentICPMSPreview" <> $SessionUUID],
				Object[Container, Vessel, "Test container 1 for ExperimentICPMSPreview" <> $SessionUUID],
				Object[Container, Bench, "Test Bench for ExperimentICPMSPreview"<>$SessionUUID]
			};

			(* Check whether the names we want to give below already exist in the database *)
			existsFilter = DatabaseMemberQ[objects];

			(* Erase any objects that we failed to erase in the last unit test. *)
			Quiet[EraseObject[PickList[objects, existsFilter], Force -> True, Verbose -> False]];
		];
	)
];


(* ::Subsection:: *)
(*ExperimentICPMSOptions*)

DefineTests[ExperimentICPMSOptions,
	{
		Example[{Basic, "Display the option values which will be used in the experiment:"},
			ExperimentICPMSOptions[{Object[Sample, "Test sample 1 for ExperimentICPMSOptions"<>$SessionUUID]}],
			_Grid
		],
		Example[{Basic,"Any potential issues with provided inputs/options will be displayed:"},
			ExperimentICPMSOptions[{Object[Sample,"Test sample 1 for ExperimentICPMSOptions"<>$SessionUUID]},
				StandardType -> None,
				ExternalStandard->Model[Sample, "ICP-MS Standard Periodic Table Mix 1 for ICP"]
			],
			_Grid,
			Messages:>{Error::ExternalStandardPresence,Error::InvalidOption}
		],
		Example[
			{Options,OutputFormat,"If OutputFormat -> List, return a list of options:"},
			ExperimentICPMSOptions[Object[Sample,"Test sample 1 for ExperimentICPMSOptions"<>$SessionUUID],
				OutputFormat->List],
			{(_Rule|_RuleDelayed)..}
		]
	},
	Stubs :> {
		$PersonID=Object[User,"Test user for notebook-less test protocols"]
	},
	SymbolSetUp :> (
		$CreatedObjects = {};
		ClearMemoization[];
		Off[Warning::SamplesOutOfStock];
		Off[Warning::InstrumentUndergoingMaintenance];
		Module[{objects, existsFilter},
			(* list of test objests *)
			objects = {
				Object[Sample, "Test sample 1 for ExperimentICPMSOptions" <> $SessionUUID],
				Object[Container, Vessel, "Test container 1 for ExperimentICPMSOptions" <> $SessionUUID],
				Object[Container, Bench, "Test Bench for ExperimentICPMSOptions"<>$SessionUUID]
			};

			(* Check whether the names we want to give below already exist in the database *)
			existsFilter = DatabaseMemberQ[objects];

			(* Erase any objects that we failed to erase in the last unit test. *)
			Quiet[EraseObject[PickList[objects, existsFilter], Force -> True, Verbose -> False]];
		];
		Module[{testBench},
			testBench = Upload[<|
				Type -> Object[Container, Bench],
				Model -> Link[Model[Container,Bench,"The Bench of Testing"],Objects],
				Name -> "Test Bench for ExperimentICPMSOptions"<>$SessionUUID,
				DeveloperObject -> True,
				StorageCondition -> Link[Model[StorageCondition,"Ambient Storage"]],
				Site -> Link[$Site]
			|>];
			Block[{$DeveloperUpload=True},
				UploadSample[Model[Container, Vessel, "15mL Tube"],
					{"Bench Top Slot", testBench},
					Name -> "Test container 1 for ExperimentICPMSOptions" <> $SessionUUID
				]
			];
			Block[{$DeveloperUpload=True},
				UploadSample[
					Model[Sample, "Milli-Q water"],
					{"A1", Object[Container, Vessel, "Test container 1 for ExperimentICPMSOptions" <> $SessionUUID]},
					InitialAmount -> 3 Milliliter,
					Name -> "Test sample 1 for ExperimentICPMSOptions" <> $SessionUUID
				]
			]
		]
	),
	SymbolTearDown :> (
		EraseObject[$CreatedObjects, Force -> True];
		Unset[$CreatedObjects];
		ClearMemoization[];
		On[Warning::SamplesOutOfStock];
		On[Warning::InstrumentUndergoingMaintenance];
		Module[{objects, existsFilter},
			(* list of test objests *)
			objects = {
				Object[Sample, "Test sample 1 for ExperimentICPMSOptions" <> $SessionUUID],
				Object[Container, Vessel, "Test container 1 for ExperimentICPMSOptions" <> $SessionUUID],
				Object[Container, Bench, "Test Bench for ExperimentICPMSOptions"<>$SessionUUID]
			};

			(* Check whether the names we want to give below already exist in the database *)
			existsFilter = DatabaseMemberQ[objects];

			(* Erase any objects that we failed to erase in the last unit test. *)
			Quiet[EraseObject[PickList[objects, existsFilter], Force -> True, Verbose -> False]];
		];
	)
];


(* ::Subsection:: *)
(*ValidExperimentICPMSQ*)
DefineTests[
	ValidExperimentICPMSQ,
	{
		Example[{Basic, "Verify that the experiment can be run without issues:"},
			ValidExperimentICPMSQ[
				Object[Sample, "Test sample 1 for ValidExperimentICPMSQ" <> $SessionUUID],
				StandardType -> External,
				Elements -> {Sodium}
			],
			True
		],
		Example[{Basic, "Return False if there are problems with the inputs or options:"},
			ValidExperimentICPMSQ[
				Object[Sample, "Test sample 1 for ValidExperimentICPMSQ" <> $SessionUUID],
				StandardType -> None,
				ExternalStandard->Model[Sample, "ICP-MS Standard Periodic Table Mix 1 for ICP"]
			],
			False
		],
		Example[{Options, OutputFormat, "Run a test summary:"},
			ValidExperimentICPMSQ[
				Object[Sample, "Test sample 1 for ValidExperimentICPMSQ" <> $SessionUUID],
				StandardType -> None,
				ExternalStandard->Model[Sample, "ICP-MS Standard Periodic Table Mix 1 for ICP"],
				OutputFormat -> TestSummary
			],
			_EmeraldTestSummary
		],
		Example[{Basic, Verbose, "Print verbose messages reporting test passage/failure:"},
			ValidExperimentICPMSQ[
				Object[Sample, "Test sample 1 for ValidExperimentICPMSQ" <> $SessionUUID],
				StandardType -> None,
				ExternalStandard->Model[Sample, "ICP-MS Standard Periodic Table Mix 1 for ICP"],
				Verbose -> True
			],
			False
		],
		Stubs :> {
			$PersonID=Object[User,"Test user for notebook-less test protocols"],
			(* ValidObjectQ is super slow so just doing this here *)
			ValidObjectQ[objs_,OutputFormat->Boolean]:=ConstantArray[True,Length[objs]]
		}
	},
	SymbolSetUp :> (
		$CreatedObjects = {};
		ClearMemoization[];
		Off[Warning::SamplesOutOfStock];
		Off[Warning::InstrumentUndergoingMaintenance];
		Module[{objects, existsFilter},
			(* list of test objests *)
			objects = {
				Object[Sample, "Test sample 1 for ValidExperimentICPMSQ" <> $SessionUUID],
				Object[Container, Vessel, "Test container 1 for ValidExperimentICPMSQ" <> $SessionUUID],
				Object[Container, Bench, "Test Bench for ValidExperimentICPMSQ"<>$SessionUUID]
			};

			(* Check whether the names we want to give below already exist in the database *)
			existsFilter = DatabaseMemberQ[objects];

			(* Erase any objects that we failed to erase in the last unit test. *)
			Quiet[EraseObject[PickList[objects, existsFilter], Force -> True, Verbose -> False]];
		];
		Module[{testBench},
			testBench = Upload[<|
				Type -> Object[Container, Bench],
				Model -> Link[Model[Container,Bench,"The Bench of Testing"],Objects],
				Name -> "Test Bench for ValidExperimentICPMSQ"<>$SessionUUID,
				DeveloperObject -> True,
				StorageCondition -> Link[Model[StorageCondition,"Ambient Storage"]],
				Site -> Link[$Site]
			|>];
			Block[{$DeveloperUpload=True},
				UploadSample[Model[Container, Vessel, "15mL Tube"],
					{"Bench Top Slot", testBench},
					Name -> "Test container 1 for ValidExperimentICPMSQ" <> $SessionUUID
				]
			];
			Block[{$DeveloperUpload=True},
				UploadSample[
					Model[Sample, "Milli-Q water"],
					{"A1", Object[Container, Vessel, "Test container 1 for ValidExperimentICPMSQ" <> $SessionUUID]},
					InitialAmount -> 3 Milliliter,
					Name -> "Test sample 1 for ValidExperimentICPMSQ" <> $SessionUUID
				]
			]
		]
	),
	SymbolTearDown :> (
		EraseObject[$CreatedObjects, Force -> True];
		Unset[$CreatedObjects];
		ClearMemoization[];
		On[Warning::SamplesOutOfStock];
		On[Warning::InstrumentUndergoingMaintenance];
		Module[{objects, existsFilter},
			(* list of test objests *)
			objects = {
				Object[Sample, "Test sample 1 for ValidExperimentICPMSQ" <> $SessionUUID],
				Object[Container, Vessel, "Test container 1 for ValidExperimentICPMSQ" <> $SessionUUID],
				Object[Container, Bench, "Test Bench for ValidExperimentICPMSQ"<>$SessionUUID]
			};

			(* Check whether the names we want to give below already exist in the database *)
			existsFilter = DatabaseMemberQ[objects];

			(* Erase any objects that we failed to erase in the last unit test. *)
			Quiet[EraseObject[PickList[objects, existsFilter], Force -> True, Verbose -> False]];
		];
	)
];