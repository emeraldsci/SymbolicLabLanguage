(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* Begin Private Context *)


(* ::Section:: *)
(*Source Code*)


(* ::Subsection:: *)
(*validInventoryQTests*)


validInventoryQTests[packet:PacketP[Object[Inventory]]]:={

	(* --------- Shared field shaping --------- *)
	NotNullFieldTest[packet,{StockedInventory, Status, Author, DateCreated, Site, StockingMethod, CurrentAmount, ReorderThreshold, ReorderAmount}],

	(* StockedInventory tests *)
	Test["For Object[Inventory, Product] objects, StockedInventory must only contain Object[Product] objects:",
		Or[
			MatchQ[packet, ObjectP[Object[Inventory, Product]]] && MatchQ[Lookup[packet, StockedInventory], {ObjectP[Object[Product]]..}],
			MatchQ[packet, ObjectP[Object[Inventory, StockSolution]]]
		],
		True
	],
	Test["For Object[Inventory, StockSolution] objects, StockedInventory must only contain Model[Sample] objects:",
		Or[
			MatchQ[packet, ObjectP[Object[Inventory, StockSolution]]] && MatchQ[Lookup[packet, StockedInventory], {ObjectP[Model[Sample]]..}],
			MatchQ[packet, ObjectP[Object[Inventory, Product]]]
		],
		True
	],

	(* more bespoke tests *)
	Test["If StockingMethod -> NumberOfStockedContainers, then CurrentAmount and ReorderThreshold (and if Object[Inventory, Product], ReorderAmount regardless of StockingMethod) must be integer units:",
		Or[
			And[
				MatchQ[packet, ObjectP[Object[Inventory, Product]]],
				MatchQ[Lookup[packet, StockingMethod], TotalAmount],
				MatchQ[Lookup[packet, ReorderAmount], UnitsP[Unit]]
			],
			And[
				MatchQ[packet, ObjectP[Object[Inventory, Product]]],
				MatchQ[Lookup[packet, StockingMethod], NumberOfStockedContainers],
				MatchQ[Lookup[packet, {CurrentAmount, ReorderThreshold, ReorderAmount}], {UnitsP[Unit], UnitsP[Unit], UnitsP[Unit]}]
			],
			And[
				MatchQ[packet, ObjectP[Object[Inventory, StockSolution]]],
				MatchQ[Lookup[packet, StockingMethod], NumberOfStockedContainers],
				MatchQ[Lookup[packet, {CurrentAmount, ReorderThreshold}], {UnitsP[Unit], UnitsP[Unit]}]
			],
			And[
				MatchQ[packet, ObjectP[Object[Inventory, StockSolution]]],
				MatchQ[Lookup[packet, StockingMethod], TotalAmount]
			]
		],
		True
	],
	Test["No order or protocol is present in HistoricalRestockings and OutstandingRestockings at the same time:",
		Intersection[
			Download[Lookup[packet, HistoricalRestockings], Object],
			Download[Lookup[packet, OutstandingRestockings], Object]
		],
		{}
	],
	(* If Expires \[Equal] True, then either ShelfLife or UnsealedShelfLife must be informed. If either ShelfLife or UnsealedShelfLife is informed, then Expires must \[Equal] True. *)
	Test["Either ShelfLife or UnsealedShelfLife must be populated if Expires is True; if either ShelfLife or UnsealedShelfLife is informed, Expires must be True:",
		Lookup[packet, {Expires, ShelfLife, UnsealedShelfLife}],
		Alternatives[
			{True, Except[NullP | {}], NullP | {}},
			{True, NullP | {}, Except[NullP | {}]},
			{True, Except[NullP | {}], Except[NullP | {}]},
			{Except[True], NullP | {}, NullP | {}}
		]
	],

	Test["If the StockedInventory is Deprecated, the Status of the Inventory cannot be active:",
		If[MatchQ[Lookup[packet, Status], Active],
			Not[MatchQ[Download[Lookup[packet, StockedInventory], Deprecated], {True..}]],
			True
		],
		True
	]
};


(* ::Subsection:: *)
(*validInventoryProductQTests*)


validInventoryProductQTests[packet:PacketP[Object[Inventory, Product]]]:={

	NotNullFieldTest[packet, {ModelStocked}],

	Test["CurrentAmount, ReorderThreshold, and ReorderAmount must have compatible units:",
		Or[
			MatchQ[Lookup[packet, {CurrentAmount, ReorderThreshold, ReorderAmount}], {UnitsP[Unit], UnitsP[Unit], UnitsP[Unit]}],
			MatchQ[Lookup[packet, {CurrentAmount, ReorderThreshold, ReorderAmount}], {UnitsP[Milliliter], UnitsP[Milliliter], UnitsP[Milliliter]|UnitsP[Unit]}],
			MatchQ[Lookup[packet, {CurrentAmount, ReorderThreshold, ReorderAmount}], {UnitsP[Milligram], UnitsP[Milligram], UnitsP[Milligram]|UnitsP[Unit]}]
		],
		True
	],

	Test["If StockingMethod -> TotalAmount, Amount field of the product to stock must match the units of ReorderThreshold:",
		If[MatchQ[Lookup[packet, StockingMethod], TotalAmount],
			Or[
				Quiet[CompatibleUnitQ[Download[FirstOrDefault[Lookup[packet, StockedInventory]], Amount], Lookup[packet, ReorderThreshold]]],
				Quiet[CompatibleUnitQ[Download[FirstOrDefault[Lookup[packet, StockedInventory]], CountPerSample], Lookup[packet, ReorderThreshold]]],
				With[{kitComponents = Download[FirstOrDefault[Lookup[packet, StockedInventory]], KitComponents]},
					Quiet[CompatibleUnitQ[
						Lookup[
							SelectFirst[kitComponents, MatchQ[Lookup[#, ProductModel], ObjectP[Lookup[packet, ModelStocked]]]&],
							Amount
						],
						Lookup[packet, ReorderThreshold]
					]]
				]
			],
			True
		],
		True
	],

	Test["Cannot stock a container that has KitProductsContainers field populated with this same product:",
		With[{kitProductsContainers = Quiet[Download[Lookup[packet, ModelStocked], KitProductsContainers]], product = Lookup[packet, StockedInventory][[1]]},
			Not[MemberQ[kitProductsContainers, ObjectP[product]]]
		],
		True
	],

	Test["If the ModelStocked is Deprecated, the Status of the Inventory cannot be active:",
		If[MatchQ[Lookup[packet, Status], Active],
			Not[MatchQ[Download[Lookup[packet, ModelStocked], Deprecated], True]],
			True
		],
		True
	]

};


(* ::Subsection:: *)
(*validInventorStockSolutionyQTests*)


validInventoryStockSolutionQTests[packet:PacketP[Object[Inventory, StockSolution]]]:={

	Test["CurrentAmount, ReorderThreshold, and ReorderAmount must have compatible units:",
		Or[
			MatchQ[Lookup[packet, {CurrentAmount, ReorderThreshold, ReorderAmount}], {UnitsP[Milliliter], UnitsP[Milliliter], UnitsP[Milliliter]}],
			MatchQ[Lookup[packet, {CurrentAmount, ReorderThreshold, ReorderAmount}], {UnitsP[Milligram], UnitsP[Milligram], UnitsP[Milligram]}],
			MatchQ[Lookup[packet, {CurrentAmount, ReorderThreshold, ReorderAmount}], {UnitsP[Unit], UnitsP[Unit], UnitsP[Unit] | UnitsP[Milligram] | UnitsP[Milliliter]}]
		],
		True
	],

	Test["ReorderAmount must be enough to reach or exceed ReorderThreshold:",
		Lookup[packet, ReorderAmount] >= Lookup[packet, ReorderThreshold],
		True
	],

	Test["If the inventory's model has volume increments and StockingMethod -> TotalAmount, then the reorder amount must be a mutliple of the volume increment:",
		Module[{model, volumeIncrements, amount},
			model = FirstOrDefault[Lookup[packet, StockedInventory]];
			volumeIncrements = Download[model, VolumeIncrements];
			amount = Lookup[packet, ReorderAmount];

			If[MatchQ[volumeIncrements, {}] || MatchQ[Lookup[packet, StockingMethod], NumberOfStockedContainers] || Not[VolumeQ[Lookup[packet, ReorderAmount]]],
				True,
				MemberQ[Rationalize[volumeIncrements /. Lookup[packet, ReorderAmount]], _Integer]
			]
		],
		True
	];

	Test["If ReorderThreshold and ReorderAmount are both above 0 and Notebook is Null, then the linked stock solution must have Price populated:",
		Module[{reorderThreshold, reorderAmount, notebook, ssPrice},
			{reorderThreshold, reorderAmount, notebook} = Lookup[packet, {ReorderThreshold, ReorderAmount, Notebook}];

			If[MatchQ[{reorderThreshold, reorderAmount}, {GreaterP[0 Gram] | GreaterP[0 Liter] | GreaterP[0 Unit], GreaterP[0 Gram] | GreaterP[0 Liter] | GreaterP[0 Unit]}] && Not[NullQ[notebook]],
				Not[NullQ[ssPrice]],
				True
			]
		],
		True
	]
};



(* ::Subsection::Closed:: *)
(*Test Registration *)


registerValidQTestFunction[Object[Inventory],validInventoryQTests];
registerValidQTestFunction[Object[Inventory, Product],validInventoryProductQTests];
registerValidQTestFunction[Object[Inventory, StockSolution],validInventoryStockSolutionQTests];