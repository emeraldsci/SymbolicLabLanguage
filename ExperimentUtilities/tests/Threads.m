(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*Unit Testing*)


(* ::Subsection::Closed:: *)
(*AvailableThreads *)


DefineTests[
	AvailableThreads,
	{
		Example[{Basic, "Returns the protocols that are using threads for each team in the input list:"},
			AvailableThreads[Object[Team, Financing, "id:54n6evLPrwb9"]],
			_Integer
		],
		Example[{Basic, "Returns the protocols that are using threads for each team in the input list:"},
			allTeamsWithQueue=Search[Object[Team, Financing], Length[Queue] > 0];

			AvailableThreads[allTeamsWithQueue],
			{_Integer..}
		],
		Example[{Additional, "Properly count the number of available threads when dealing with IncubateCells InstrumentProcessing protocols that shouldn't count against the number:"},
			AvailableThreads[Object[Team, Financing, "Test Team for AvailableThreads" <> $SessionUUID]],
			3
		]
	},
	SymbolSetUp :> (
		Module[{allObjects, existingObjects},
			(*Gather all the objects and models created in SymbolSetUp*)
			allObjects = {
				Object[Team, Financing, "Test Team for AvailableThreads" <> $SessionUUID],
				Object[LaboratoryNotebook, "Test Notebook for AvailableThreads" <> $SessionUUID],
				Object[User, "Test User for AvailableThreads" <> $SessionUUID],

				Object[Container, Vessel, "AvailableThreads Cell Flask 1" <> $SessionUUID],
				Object[Container, Vessel, "AvailableThreads Cell Flask 2" <> $SessionUUID],
				Object[Container, Vessel, "AvailableThreads Cell Flask 3" <> $SessionUUID],

				Object[Sample, "AvailableThreads bacterial sample 1 " <> $SessionUUID],
				Object[Sample, "AvailableThreads bacterial sample 2 " <> $SessionUUID],
				Object[Sample, "AvailableThreads bacterial sample 3 " <> $SessionUUID],

				Object[Protocol, ManualCellPreparation, "Test MCP for AvailableThreads unit tests" <> $SessionUUID],
				Object[Protocol, IncubateCells, "AvailableThreads IncubateCells protocol in OperatorProcessing " <> $SessionUUID],
				Object[Protocol, IncubateCells, "AvailableThreads IncubateCells protocol in InstrumentProcessing with a custom incubator " <> $SessionUUID],
				Object[Protocol, IncubateCells, "AvailableThreads IncubateCells protocol in InstrumentProcessing as a sub " <> $SessionUUID],

				Object[Container, Bench, "Test bench for AvailableThreads tests" <> $SessionUUID],
				Model[Sample, "Bacterial cells Model (for AvailableThreads)" <> $SessionUUID],

				Object[Item, Cap, "Cap 1 for AvailableThreads tests " <> $SessionUUID],
				Object[Item, Cap, "Cap 2 for AvailableThreads tests " <> $SessionUUID],
				Object[Item, Cap, "Cap 3 for AvailableThreads tests " <> $SessionUUID]
			};

			(*Check whether the names we want to give below already exist in the database*)
			existingObjects = PickList[allObjects, DatabaseMemberQ[allObjects]];

			(*Erase any test objects and models that we failed to erase in the last unit test*)
			Quiet[EraseObject[existingObjects, Force -> True, Verbose -> False]]
		];

		Block[{$DeveloperUpload = True},
			Module[
				{testBench, team1, notebook1, user1, flask1, flask2, flask3,
					bacteriaModel,flaskSample1, flaskSample2, flaskSample3, cap1, cap2, cap3,
					mcpParentProt1, incubateCellsProtInInstProcessing,
					incubateCellsProtInOperatorProcessing, incubateCellsProtInInstProcessingCustom
				},
				team1 = Upload[<|
					Type -> Object[Team, Financing],
					Name -> "Test Team for AvailableThreads" <> $SessionUUID,
					MaxThreads -> 5,
					Replace[ExperimentSites] -> {Link[$Site, FinancingTeams]},
					Notebook -> Null,
					(* this needs to not be True because UploadProtocolStatus gets grumpy if the Team is DeveloperObject because then it doesn't want to update the field *)
					DeveloperObject -> False
				|>];

				{
					notebook1,
					user1
				} = Block[{$AllowPublicObjects = True},
					Upload[{
						<|
							Type -> Object[LaboratoryNotebook],
							Name -> "Test Notebook for AvailableThreads" <> $SessionUUID,
							Replace[Financers] -> {Link[team1, NotebooksFinanced]},
							Replace[Editors] -> {Link[team1, Notebooks]}
						|>,
						<|
							Type -> Object[User],
							Name -> "Test User for AvailableThreads" <> $SessionUUID,
							Replace[FinancingTeams] -> {Link[team1, Members]},
							Notebook -> Null
						|>
					}]
				];

				testBench = Upload[<|Type -> Object[Container, Bench], Model -> Link[Model[Container, Bench, "The Bench of Testing"], Objects], Name -> "Test bench for AvailableThreads tests" <> $SessionUUID, Site -> Link[$Site], DeveloperObject -> True, StorageCondition -> Link[Model[StorageCondition, "Ambient Storage"]]|>];

				(* Upload some tubes and flasks *)
				{
					flask1,
					flask2,
					flask3
				} = ECL`InternalUpload`UploadSample[
					{
						Model[Container, Vessel, "Corning 250mL Vented Polycarbonate Erlenmeyer Flask"],
						Model[Container, Vessel, "Corning 250mL Vented Polycarbonate Erlenmeyer Flask"],
						Model[Container, Vessel, "Corning 250mL Vented Polycarbonate Erlenmeyer Flask"]
					},
					{
						{"Work Surface", testBench},
						{"Work Surface", testBench},
						{"Work Surface", testBench}
					},
					Name -> {
						"AvailableThreads Cell Flask 1" <> $SessionUUID,
						"AvailableThreads Cell Flask 2" <> $SessionUUID,
						"AvailableThreads Cell Flask 3" <> $SessionUUID
					},
					Notebook -> Null
				];


				bacteriaModel = UploadSampleModel[
					"Bacterial cells Model (for AvailableThreads)" <> $SessionUUID,
					Composition -> {{95 VolumePercent, Model[Molecule, "Water"]}, {5 VolumePercent, Model[Cell, Bacteria, "E.coli MG1655"]}},
					Expires -> False,
					DefaultStorageCondition -> Model[StorageCondition, "Bacterial Incubation with Shaking"],
					State -> Liquid,
					BiosafetyLevel -> "BSL-1",
					Flammable -> False,
					MSDSFile -> NotApplicable,
					IncompatibleMaterials -> {None},
					CellType -> Bacterial,
					CultureAdhesion -> Suspension,
					Living -> True
				];

				(* Create water samples in the tubes and the bacterial samples in the flasks *)
				{
					flaskSample1,
					flaskSample2,
					flaskSample3
				} = Block[{$AllowPublicObjects = True}, ECL`InternalUpload`UploadSample[
					{
						bacteriaModel,
						bacteriaModel,
						bacteriaModel
					},
					{
						{"A1", flask1},
						{"A1", flask2},
						{"A1", flask3}
					},
					Name -> {
						"AvailableThreads bacterial sample 1 " <> $SessionUUID,
						"AvailableThreads bacterial sample 2 " <> $SessionUUID,
						"AvailableThreads bacterial sample 3 " <> $SessionUUID
					},
					InitialAmount -> {
						100 Milliliter,
						100 Milliliter,
						100 Milliliter
					},
					Notebook -> Null
				]];

				{
					cap1,
					cap2,
					cap3
				} = ECL`InternalUpload`UploadSample[
					{
						Model[Item, Cap, "Flask Cap, Breathable 49x30mm"],
						Model[Item, Cap, "Flask Cap, Breathable 49x30mm"],
						Model[Item, Cap, "Flask Cap, Breathable 49x30mm"]
					},
					{
						{"Work Surface", testBench},
						{"Work Surface", testBench},
						{"Work Surface", testBench}
					},
					Name -> {
						"Cap 1 for AvailableThreads tests " <> $SessionUUID,
						"Cap 2 for AvailableThreads tests " <> $SessionUUID,
						"Cap 3 for AvailableThreads tests " <> $SessionUUID
					},
					FastTrack -> True
				];

				ECL`InternalUpload`UploadCover[
					{flask1, flask2, flask3},
					Cover -> {cap1, cap2, cap3}
				];

				(* Get all containers and samples in the test notebook *)
				Block[{$AllowPublicObjects = True}, ECL`InternalUpload`UploadNotebook[
					{
						flask1, flask2, flask3,
						flaskSample1, flaskSample2, flaskSample3,
						cap1, cap2, cap3
					},
					notebook1
				]];

				Block[{$Notebook = notebook1, $PersonID = user1, $AllowPublicObjects = True, ProductionQ},

					(* need to block ProductionQ to be True because that's the only way for the Queue field to get updated automatically when doing UploadProtocolStatus and the Queue field is what these tests rely on *)
					ProductionQ[]:=True;

					(* generate an IncubateCells protocol that needs to get aborted (so it has to be in OperatorProcessing, not OperatorReady) *)
					incubateCellsProtInOperatorProcessing = ECL`ExperimentIncubateCells[
						flaskSample1,
						Name -> "AvailableThreads IncubateCells protocol in OperatorProcessing " <> $SessionUUID,
						Confirm -> True
					];
					ECL`InternalUpload`UploadProtocolStatus[incubateCellsProtInOperatorProcessing, OperatorProcessing];


					(* generate an IncubateCells protocol that needs to get completed *)
					incubateCellsProtInInstProcessingCustom = ECL`ExperimentIncubateCells[
						flaskSample2,
						Name -> "AvailableThreads IncubateCells protocol in InstrumentProcessing with a custom incubator " <> $SessionUUID,
						Incubator -> Model[Instrument, Incubator, "Multitron Pro with 25mm Orbit"],
						Confirm -> True
					];
					ECL`InternalUpload`UploadProtocolStatus[incubateCellsProtInInstProcessingCustom, InstrumentProcessing];

					(* make an MCP protocol to use as a ParentProtocol so we can interrogate the  *)
					mcpParentProt1 = ECL`ExperimentManualCellPreparation[
						{
							IncubateCells[Sample -> flaskSample3]
						},
						Name -> "Test MCP for AvailableThreads unit tests" <> $SessionUUID,
						Confirm -> True
					];

					(* generate an IncubateCells protocol that needs to get set to InstrumentProcessing and is a subprotocol (and thus will change the backlog because it won't count against the number of threads anymore) *)
					incubateCellsProtInInstProcessing = ECL`ExperimentIncubateCells[
						flaskSample3,
						Name -> "AvailableThreads IncubateCells protocol in InstrumentProcessing as a sub " <> $SessionUUID,
						ParentProtocol -> mcpParentProt1,
						Confirm -> True
					];
					ECL`InternalUpload`UploadProtocolStatus[{mcpParentProt1, incubateCellsProtInInstProcessing}, InstrumentProcessing, FastTrack -> True, UpdatedBy -> incubateCellsProtInInstProcessing]
				];

			]
		]
	)
];



(* ::Subsection::Closed:: *)
(*OpenThreads *)


DefineTests[
	OpenThreads,
	{
		Example[{Basic, "Returns the protocols that are using threads for each team in the input list (single team):"},
			OpenThreads[Object[Team, Financing, "id:54n6evLPrwb9"]],
			{ObjectP[{Object[Protocol], Object[Qualification], Object[Maintenance]}] ...}
		],
		Example[{Basic, "Returns the protocols that are using threads for each team in the input list (multiple teams):"},
			allTeamsWithQueue=Search[Object[Team, Financing], Length[Queue] > 0];

			OpenThreads[allTeamsWithQueue],
			{{ObjectP[{Object[Protocol], Object[Qualification], Object[Maintenance]}] ...} ...}
		]
	}
];
