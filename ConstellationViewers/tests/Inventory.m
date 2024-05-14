DefineTests[
	PlotInventory,
	{
		Example[{Basic, "Plot the basic inventory dashboard on a notebook:"},
			Head[PlotInventory[Object[LaboratoryNotebook, "Dima Scratch"]]],
			TableForm
		],
		Example[{Basic, "Plot the basic inventory dashboard on multiple notebooks:"},
			Head[PlotInventory[{Object[LaboratoryNotebook, "Dima Scratch"]}]],
			TableForm
		],
		Example[{Basic, "Plot the basic inventory dashboard on a notebooks with a search term:"},
			Head[PlotInventory[Object[LaboratoryNotebook, "Dima Scratch"], "gluconate"]],
			TableForm
		],
		Example[{Basic, "Plot the basic inventory dashboard on multiple notebooks with a search term:"},
			Head[PlotInventory[{Object[LaboratoryNotebook, "Dima Scratch"]}, "gluconate"]],
			TableForm
		],
		Example[{Options, "OutputFormat", "Write the output of the inventory dashboard to a csv file:"},
			Head[PlotInventory[{Object[LaboratoryNotebook, "Dima Scratch"]}, "gluconate", OutputFormat -> FileNameJoin[{$TemporaryDirectory, "InventoryDashboard.csv"}]]],
			String
		]
	}
];

DefineTests[
	inventoryDashboardJSON,
	{
		Test["Inventory dashboard responses can be parsed to an association:",
			inventoryDashboardJSON[{testNotebook}, OutputFormat -> Association],
			_Association
		],
		Test["Inventory dashboard responses can be parsed to a JSON string format:",
			inventoryDashboardJSON[{testNotebook}, OutputFormat -> String],
			_String
		],
		Test["Inventory dashboard responses parsed to a string JSON format can be re-imported as a valid association:",
			ImportJSONToAssociation@inventoryDashboardJSON[{testNotebook}, OutputFormat -> String],
			_Association
		],
		Test["Inventory dashboard response sections are grouped properly:",
			Module[{responseJSON},
				responseJSON = inventoryDashboardJSON[{testNotebook}, OutputFormat -> Association];
				Length[responseJSON[["results"]]]
			],
			2
		],
		Test["Inventory dashboard responses have correctly-formed fields:",
			Module[{responseJSON, fields},
				responseJSON = inventoryDashboardJSON[{testNotebook}, OutputFormat -> Association];
				{
					responseJSON[["results"]][[1]][["section_name"]],
					responseJSON[["results"]][[1]][["rows"]][[1]][["site"]],
					responseJSON[["results"]][[1]][["rows"]][[1]][["model"]][["name"]],
					responseJSON[["results"]][[1]][["rows"]][[1]][["amount"]]
				}
			],
			{
				Alternatives["Model[Sample]", "Model[Sample, StockSolution]"],
				Alternatives["Inventory Dashboard Testing Site 1 " <> $SessionUUID, "Inventory Dashboard Testing Site 2 " <> $SessionUUID],
				Alternatives["Sodium Chloride", "5M Sodium Hydroxide"],
				"150 kilograms"
			}
		]
	},
	Stubs :> {
		testNotebook = Object[LaboratoryNotebook, "Inventory Dashboard Testing Notebook " <> $SessionUUID]
	},
	SymbolSetUp :> {
		$CreatedObjects = {};
		Module[{testSite1, testSite2, testTeam, testUser, testNotebook, testInventoryProduct1, testInventoryProduct2, testInventoryProduct3},
			testSite1 = Upload[<|
				DeveloperObject -> True,
				Type -> Object[Container, Site],
				Name -> "Inventory Dashboard Testing Site 1 " <> $SessionUUID
			|>];
			testSite2 = Upload[<|
				DeveloperObject -> True,
				Type -> Object[Container, Site],
				Name -> "Inventory Dashboard Testing Site 2 " <> $SessionUUID
			|>];
			testTeam = Upload[<|
				DeveloperObject -> True,
				Type -> Object[Team, Financing],
				Name -> "Inventory Dashboard Testing Team " <> $SessionUUID,
				DefaultMailingAddress -> Link[testSite1]
			|>];
			testUser = Upload[<|
				DeveloperObject -> True,
				Type -> Object[User, Emerald, Developer],
				HireDate -> Now,
				Name -> "Inventory Dashboard Testing User " <> $SessionUUID,
				LastName -> $SessionUUID
			|>];
			testNotebook = Upload[<|
				DeveloperObject -> True,
				Type -> Object[LaboratoryNotebook],
				Name -> "Inventory Dashboard Testing Notebook " <> $SessionUUID,
				Replace[Financers] -> {Link[testTeam, NotebooksFinanced]},
				Replace[Administrators] -> {Link[testUser]}
			|>];
			testInventoryProduct1 = Upload[<|
				Type -> Object[Inventory, Product],
				Name -> "Inventory Dashboard Testing Inv. Product 1 " <> $SessionUUID,
				Replace[OutstandingRestockings] -> {},
				CurrentAmount -> 150 Kilo Gram,
				Status -> Active,
				Author -> Link[testUser],
				DateCreated -> Now,
				StockingMethod -> TotalAmount,
				ReorderThreshold -> 100 Kilo Gram,
				ReorderAmount -> 5 Kilo Gram,
				Expires -> False,
				Site -> Link[testSite1],
				ModelStocked -> Link[Model[Sample, "Sodium Chloride"]],
				Notebook -> Link[testNotebook, Objects]
			|>];
			testInventoryProduct2 = Upload[<|
				Type -> Object[Inventory, Product],
				Name -> "Inventory Dashboard Testing Inv. Product 2 " <> $SessionUUID,
				Replace[OutstandingRestockings] -> {},
				CurrentAmount -> 150 Kilo Gram,
				Status -> Active,
				Author -> Link[testUser],
				DateCreated -> Now,
				StockingMethod -> TotalAmount,
				ReorderThreshold -> 100 Kilo Gram,
				ReorderAmount -> 5 Kilo Gram,
				Expires -> False,
				Site -> Link[testSite2],
				ModelStocked -> Link[Model[Sample, "Sodium Chloride"]],
				Notebook -> Link[testNotebook, Objects]
			|>];
			testInventoryProduct3 = Upload[<|
				Type -> Object[Inventory, Product],
				Name -> "Inventory Dashboard Testing Inv. Product 3 " <> $SessionUUID,
				Replace[OutstandingRestockings] -> {},
				CurrentAmount -> 150 Kilo Gram,
				Status -> Active,
				Author -> Link[testUser],
				DateCreated -> Now,
				StockingMethod -> TotalAmount,
				ReorderThreshold -> 100 Kilo Gram,
				ReorderAmount -> 5 Kilo Gram,
				Expires -> False,
				Site -> Link[testSite2],
				ModelStocked -> Link[Model[Sample, StockSolution, "5M Sodium Hydroxide"]],
				Notebook -> Link[testNotebook, Objects]
			|>];
		]
	},
	SymbolTearDown :> {
		EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
		Unset[$CreatedObjects]
	}
]
