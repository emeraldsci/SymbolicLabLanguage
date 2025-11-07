(*::Subsection::*)
(*UploadThawCellsMethod*)

DefineTests[
	UploadThawCellsMethod,
	{
		Example[{Basic, "Create a method to thaw cells and then associate it with a Model[Cell]:"},
			myThawMethod = UploadThawCellsMethod[
				"My Thaw Cells Method (Test for UploadThawCellsMethod) " <> $SessionUUID,
				Instrument -> Model[Instrument, CellThaw, "id:E8zoYveRllXB"]
			];

			UploadSampleModel[
				"Test Cryo Cell Sample for UploadThawCellsMethod " <> $SessionUUID,
				Composition -> {
					{5 VolumePercent, Model[Cell, Mammalian, "HeLa"]},
					{95 VolumePercent, Model[Molecule, "Glycerol"]}
				},
				(* Glycerol *)
				Media -> Model[Sample, "id:jLq9jXY4kkmW"],
				Expires -> True,
				UnsealedShelfLife -> 6 Month,
				ShelfLife -> 1 Year,
				DefaultStorageCondition -> Model[StorageCondition, "Cryogenic Storage"],
				State -> Liquid,
				BiosafetyLevel -> "BSL-2",
				Flammable -> False,
				MSDSFile -> NotApplicable,
				IncompatibleMaterials -> {None},
				ThawCellsMethod -> myThawMethod,
				Living->True
			],
			ObjectP[Model[Sample]],
			SetUp :> {
				If[DatabaseMemberQ[Object[Method, ThawCells, "My Thaw Cells Method (Test for UploadThawCellsMethod) " <> $SessionUUID]],
					EraseObject[Object[Method, ThawCells, "My Thaw Cells Method (Test for UploadThawCellsMethod) " <> $SessionUUID], Force -> True, Verbose -> False]
				];

				If[DatabaseMemberQ[Model[Sample, "Test Cryo Cell Sample for UploadThawCellsMethod " <> $SessionUUID]],
					EraseObject[Model[Sample, "Test Cryo Cell Sample for UploadThawCellsMethod " <> $SessionUUID], Force -> True, Verbose -> False]
				];
			},
			TearDown :> {
				If[DatabaseMemberQ[Object[Method, ThawCells, "My Thaw Cells Method (Test for UploadThawCellsMethod) " <> $SessionUUID]],
					EraseObject[Object[Method, ThawCells, "My Thaw Cells Method (Test for UploadThawCellsMethod) " <> $SessionUUID], Force -> True, Verbose -> False]
				];

				If[DatabaseMemberQ[Model[Sample, "Test Cryo Cell Sample for UploadThawCellsMethod " <> $SessionUUID]],
					EraseObject[Model[Sample, "Test Cryo Cell Sample for UploadThawCellsMethod " <> $SessionUUID], Force -> True, Verbose -> False]
				];
			}
		]
	}
];

(*::Subsection::*)
(*UploadThawCellsMethodOptions*)

DefineTests[
	UploadThawCellsMethodOptions,
	{
		Example[{Basic, "Output all of the parameters when creating a new ThawCells method:"},
			UploadThawCellsMethodOptions[
				"My Thaw Cells Method (Test for UploadThawCellsMethodOptions) " <> $SessionUUID,
				Instrument -> Model[Instrument, CellThaw, "id:E8zoYveRllXB"],
				OutputFormat -> List
			],
			{__Rule}
		],
		Example[{Options, OutputFormat, "If OutputFormat -> List, return a list of options:"},
			UploadThawCellsMethodOptions[
				"My Thaw Cells Method (Test for UploadThawCellsMethodOptions) " <> $SessionUUID,
				Instrument -> Model[Instrument, CellThaw, "id:E8zoYveRllXB"],
				OutputFormat -> List
			],
			{__Rule}
		]
	},
	SymbolSetUp :> {
		If[DatabaseMemberQ[Object[Method, ThawCells, "My Thaw Cells Method (Test for UploadThawCellsMethodOptions) " <> $SessionUUID]],
			EraseObject[Object[Method, ThawCells, "My Thaw Cells Method (Test for UploadThawCellsMethodOptions) " <> $SessionUUID], Force -> True, Verbose -> False]
		];

		If[DatabaseMemberQ[Model[Sample, "Test Cryo Cell Sample for UploadThawCellsMethodOptions " <> $SessionUUID]],
			EraseObject[Model[Sample, "Test Cryo Cell Sample for UploadThawCellsMethodOptions " <> $SessionUUID], Force -> True, Verbose -> False]
		];
	},
	SymbolTearDown :> {
		If[DatabaseMemberQ[Object[Method, ThawCells, "My Thaw Cells Method (Test for UploadThawCellsMethodOptions) " <> $SessionUUID]],
			EraseObject[Object[Method, ThawCells, "My Thaw Cells Method (Test for UploadThawCellsMethodOptions) " <> $SessionUUID], Force -> True, Verbose -> False]
		];

		If[DatabaseMemberQ[Model[Sample, "Test Cryo Cell Sample for UploadThawCellsMethodOptions " <> $SessionUUID]],
			EraseObject[Model[Sample, "Test Cryo Cell Sample for UploadThawCellsMethodOptions " <> $SessionUUID], Force -> True, Verbose -> False]
		];
	}
];


(*::Subsection::*)
(*ValidUploadThawCellsMethodQ*)

DefineTests[
	ValidUploadThawCellsMethodQ,
	{
		Example[{Basic, "Validate the creation of a new ThawCells method:"},
			ValidUploadThawCellsMethodQ[
				"My Thaw Cells Method (Test for ValidUploadThawCellsMethodQ) " <> $SessionUUID,
				Instrument -> Model[Instrument, CellThaw, "id:E8zoYveRllXB"]
			],
			True
		],
		Example[{Options, Verbose, "If Verbose->Failures, any invalid options will be printed in the notebook:"},
			ValidUploadThawCellsMethodQ[
				"My Thaw Cells Method (Test for ValidUploadThawCellsMethodQ) " <> $SessionUUID,
				Instrument -> Model[Instrument, CellThaw, "id:E8zoYveRllXB"],
				Verbose -> Failures
			],
			True
		],
		Example[{Options, OutputFormat, "If OutputFormat -> EmeraldTestSummary, return an emerald test summary:"},
			ValidUploadThawCellsMethodQ[
				"My Thaw Cells Method (Test for ValidUploadThawCellsMethodQ) " <> $SessionUUID,
				Instrument -> Model[Instrument, CellThaw, "id:E8zoYveRllXB"],
				OutputFormat -> TestSummary
			],
			_EmeraldTestSummary
		]
	},
	SymbolSetUp :> {
		If[DatabaseMemberQ[Object[Method, ThawCells, "My Thaw Cells Method (Test for ValidUploadThawCellsMethodQ) " <> $SessionUUID]],
			EraseObject[Object[Method, ThawCells, "My Thaw Cells Method (Test for ValidUploadThawCellsMethodQ) " <> $SessionUUID], Force -> True, Verbose -> False]
		];

		If[DatabaseMemberQ[Model[Sample, "Test Cryo Cell Sample for ValidUploadThawCellsMethodQ " <> $SessionUUID]],
			EraseObject[Model[Sample, "Test Cryo Cell Sample for ValidUploadThawCellsMethodQ " <> $SessionUUID], Force -> True, Verbose -> False]
		];
	},
	SymbolTearDown :> {
		If[DatabaseMemberQ[Object[Method, ThawCells, "My Thaw Cells Method (Test for ValidUploadThawCellsMethodQ) " <> $SessionUUID]],
			EraseObject[Object[Method, ThawCells, "My Thaw Cells Method (Test for ValidUploadThawCellsMethodQ) " <> $SessionUUID], Force -> True, Verbose -> False]
		];

		If[DatabaseMemberQ[Model[Sample, "Test Cryo Cell Sample for ValidUploadThawCellsMethodQ " <> $SessionUUID]],
			EraseObject[Model[Sample, "Test Cryo Cell Sample for ValidUploadThawCellsMethodQ " <> $SessionUUID], Force -> True, Verbose -> False]
		];
	}
];

