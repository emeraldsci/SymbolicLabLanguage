(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsection::Closed:: *)
(*PrintStickers*)


(* ::Subsubsection::Closed:: *)
(*PrintStickers*)


DefineTests[
	PrintStickers,
	{

		(* --- Basic --- *)

		Example[
			{Basic, "Print a sticker for a single object:"},
			PrintStickers[
				Object[Sample, "id:kEJ9mqa154dV"],
				Print -> False
			],
			{_NotebookObject},
			TearDown :> {
				NotebookClose /@ Notebooks["Sticker Printing Output"]
			}
		],

		Example[
			{Basic, "Print stickers for a list of objects:"},
			PrintStickers[
				{
					Object[Sample, "id:kEJ9mqa154dV"],
					Object[Sample, "id:P5ZnEj4l6DLl"],
					Object[Container, Plate, "id:M8n3rxYAoe1R"]
				},
				Print -> False
			],
			{_NotebookObject},
			TearDown :> {
				NotebookClose /@ Notebooks["Sticker Printing Output"]
			}
		],

		Example[
			{Basic, "Print a sticker for all containers and items shipped in a transaction:"},
			PrintStickers[
				Object[Transaction, ShipToECL, "Test transaction with items and containers for PrintStickers"],
				Print -> False
			],
			{_NotebookObject},
			TearDown :> {
				NotebookClose /@ Notebooks["Sticker Printing Output"];
				EraseObject[
					Flatten[{
						Download[Object[Transaction, ShipToECL, "Test transaction with items and containers for PrintStickers"], {ReceivedSamples[Object], ReceivedContainers[Object]}],
						Object[Transaction, ShipToECL, "Test transaction with containers only"],
						Object[Transaction, ShipToECL, "Test transaction with items and containers for PrintStickers"],
						Object[Transaction, ShipToECL, "Test transaction with items only"]
					}], Force -> True, Verbose -> True]
			},
			SetUp :> {
				Module[{sampleModel, columnModel, containerModel, sample, columnNamed, columnNoName, containerNamed, containerNoName, emptyContainer},

					sampleModel=If[!DatabaseMemberQ[Model[Sample, "Test sample model for PrintStickers"]],
						Upload[<|
							Type -> Model[Sample],
							Name -> "Test sample model for PrintStickers",
							DeveloperObject -> True
						|>]
					];

					columnModel=If[!DatabaseMemberQ[Model[Item, Column, "Test column model for PrintStickers"]],
						Upload[<|
							Type -> Model[Item, Column],
							Name -> "Test column model for PrintStickers",
							DeveloperObject -> True
						|>]
					];

					containerModel=If[!DatabaseMemberQ[Model[Container, Vessel, "Test container model for PrintStickers"]],
						Upload[<|
							Type -> Model[Container, Vessel],
							Name -> "Test container model for PrintStickers",
							DeveloperObject -> True
						|>]
					];

					sample=If[!DatabaseMemberQ[Object[Sample, "Test sample for PrintStickers"]],
						Upload[<|
							Type -> Object[Sample],
							Name -> "Test sample for PrintStickers",
							DeveloperObject -> True,
							Model -> Link[Model[Sample, "Test sample model for PrintStickers"], Objects]
						|>]
					];

					columnNamed=If[!DatabaseMemberQ[Object[Item, Column, "Test column for PrintStickers"]],
						Upload[<|
							Type -> Object[Item, Column],
							Name -> "Test column for PrintStickers",
							DeveloperObject -> True,
							Model -> Link[Model[Item, Column, "Test column model for PrintStickers"], Objects]
						|>]
					];

					columnNoName=Upload[<|
						Type -> Object[Item, Column],
						Name -> Null,
						DeveloperObject -> True,
						Model -> Link[Model[Item, Column, "Test column model for PrintStickers"], Objects]
					|>];

					containerNamed=If[!DatabaseMemberQ[Object[Container, Vessel, "Test container for PrintStickers"]],
						Upload[<|
							Type -> Object[Container, Vessel],
							Name -> "Test container for PrintStickers",
							DeveloperObject -> True,
							Model -> Link[Model[Container, Vessel, "Test container model for PrintStickers"], Objects]
						|>]
					];

					containerNoName=Upload[<|
						Type -> Object[Container, Vessel],
						Name -> Null,
						DeveloperObject -> True,
						Model -> Link[Model[Container, Vessel, "Test container model for PrintStickers"], Objects]
					|>];

					emptyContainer=Upload[<|
						Type -> Object[Container, Vessel],
						Name -> Null,
						DeveloperObject -> True,
						Model -> Link[Model[Container, Vessel, "Test container model for PrintStickers"], Objects]
					|>];

					If[!DatabaseMemberQ[Object[Transaction, ShipToECL, "Test transaction with items and containers for PrintStickers"]],
						Upload[<|
							Type -> Object[Transaction, ShipToECL],
							Name -> "Test transaction with items and containers for PrintStickers",
							DeveloperObject -> True,
							Replace[ReceivedSamples] -> {Link[sample], Link[columnNamed], Link[columnNoName]},
							Replace[ReceivedContainers] -> {Link[containerNamed], Link[containerNoName]},
							Replace[EmptyContainers] -> {Link[emptyContainer]}
						|>]
					];

					If[!DatabaseMemberQ[Object[Transaction, ShipToECL, "Test transaction with containers only"]],
						Upload[<|
							Type -> Object[Transaction, ShipToECL],
							Name -> "Test transaction with containers only",
							DeveloperObject -> True,
							Replace[ReceivedSamples] -> {Link[sample]},
							Replace[ReceivedContainers] -> {Link[containerNamed], Link[containerNoName]}
						|>]
					];

					If[!DatabaseMemberQ[Object[Transaction, ShipToECL, "Test transaction with items only"]],
						Upload[<|
							Type -> Object[Transaction, ShipToECL],
							Name -> "Test transaction with items only",
							DeveloperObject -> True,
							Replace[ReceivedSamples] -> {Link[columnNamed], Link[columnNoName]}
						|>]
					];
				]
			}
		],
		Test["Printing a sticker sets the NewStickerPrinted field on the object:",
			Module[{},
				PrintStickers[
					Object[Sample, "id:kEJ9mqa154dV"],
					Print -> False
				];

				Download[Object[Sample, "id:kEJ9mqa154dV"], NewStickerPrinted]
			],
			True,
			SetUp:>{
				Upload[<|Object->Object[Sample, "id:kEJ9mqa154dV"], NewStickerPrinted->Null|>];
			},
			TearDown :> {
				NotebookClose /@ Notebooks["Sticker Printing Output"]
			}
		],
		Test["Print a sticker for all containers and items shipped in a transaction (transaction with items only):",
			PrintStickers[
				Object[Transaction, ShipToECL, "Test transaction with items only"],
				Print -> False
			],
			{_NotebookObject},
			TearDown :> {
				NotebookClose /@ Notebooks["Sticker Printing Output"];
				EraseObject[
					Flatten[{
						Download[Object[Transaction, ShipToECL, "Test transaction with items and containers for PrintStickers"], {ReceivedSamples[Object], ReceivedContainers[Object]}],
						Object[Transaction, ShipToECL, "Test transaction with containers only"],
						Object[Transaction, ShipToECL, "Test transaction with items and containers for PrintStickers"],
						Object[Transaction, ShipToECL, "Test transaction with items only"]
					}], Force -> True, Verbose -> True]
			},
			SetUp :> {
				Module[{sampleModel, columnModel, containerModel, sample, columnNamed, columnNoName, containerNamed, containerNoName, emptyContainer},

					sampleModel=If[!DatabaseMemberQ[Model[Sample, "Test sample model for PrintStickers"]],
						Upload[<|
							Type -> Model[Sample],
							Name -> "Test sample model for PrintStickers",
							DeveloperObject -> True
						|>]
					];

					columnModel=If[!DatabaseMemberQ[Model[Item, Column, "Test column model for PrintStickers"]],
						Upload[<|
							Type -> Model[Item, Column],
							Name -> "Test column model for PrintStickers",
							DeveloperObject -> True
						|>]
					];

					containerModel=If[!DatabaseMemberQ[Model[Container, Vessel, "Test container model for PrintStickers"]],
						Upload[<|
							Type -> Model[Container, Vessel],
							Name -> "Test container model for PrintStickers",
							DeveloperObject -> True
						|>]
					];

					sample=If[!DatabaseMemberQ[Object[Sample, "Test sample for PrintStickers"]],
						Upload[<|
							Type -> Object[Sample],
							Name -> "Test sample for PrintStickers",
							DeveloperObject -> True,
							Model -> Link[Model[Sample, "Test sample model for PrintStickers"], Objects]
						|>]
					];

					columnNamed=If[!DatabaseMemberQ[Object[Item, Column, "Test column for PrintStickers"]],
						Upload[<|
							Type -> Object[Item, Column],
							Name -> "Test column for PrintStickers",
							DeveloperObject -> True,
							Model -> Link[Model[Item, Column, "Test column model for PrintStickers"], Objects]
						|>]
					];

					columnNoName=Upload[<|
						Type -> Object[Item, Column],
						Name -> Null,
						DeveloperObject -> True,
						Model -> Link[Model[Item, Column, "Test column model for PrintStickers"], Objects]
					|>];

					containerNamed=If[!DatabaseMemberQ[Object[Container, Vessel, "Test container for PrintStickers"]],
						Upload[<|
							Type -> Object[Container, Vessel],
							Name -> "Test container for PrintStickers",
							DeveloperObject -> True,
							Model -> Link[Model[Container, Vessel, "Test container model for PrintStickers"], Objects]
						|>]
					];

					containerNoName=Upload[<|
						Type -> Object[Container, Vessel],
						Name -> Null,
						DeveloperObject -> True,
						Model -> Link[Model[Container, Vessel, "Test container model for PrintStickers"], Objects]
					|>];

					emptyContainer=Upload[<|
						Type -> Object[Container, Vessel],
						Name -> Null,
						DeveloperObject -> True,
						Model -> Link[Model[Container, Vessel, "Test container model for PrintStickers"], Objects]
					|>];

					If[!DatabaseMemberQ[Object[Transaction, ShipToECL, "Test transaction with items and containers for PrintStickers"]],
						Upload[<|
							Type -> Object[Transaction, ShipToECL],
							Name -> "Test transaction with items and containers for PrintStickers",
							DeveloperObject -> True,
							Replace[ReceivedSamples] -> {Link[sample], Link[columnNamed], Link[columnNoName]},
							Replace[ReceivedContainers] -> {Link[containerNamed], Link[containerNoName]},
							Replace[EmptyContainers] -> {Link[emptyContainer]}
						|>]
					];

					If[!DatabaseMemberQ[Object[Transaction, ShipToECL, "Test transaction with containers only"]],
						Upload[<|
							Type -> Object[Transaction, ShipToECL],
							Name -> "Test transaction with containers only",
							DeveloperObject -> True,
							Replace[ReceivedSamples] -> {Link[sample]},
							Replace[ReceivedContainers] -> {Link[containerNamed], Link[containerNoName]}
						|>]
					];

					If[!DatabaseMemberQ[Object[Transaction, ShipToECL, "Test transaction with items only"]],
						Upload[<|
							Type -> Object[Transaction, ShipToECL],
							Name -> "Test transaction with items only",
							DeveloperObject -> True,
							Replace[ReceivedSamples] -> {Link[columnNamed], Link[columnNoName]}
						|>]
					];
				]
			}
		],
		Test["Transaction overload is tolerant of Null entries in ReceivedContainers:",
			PrintStickers[
				Object[Transaction, ShipToECL, "Test transaction with items only"],
				Print -> False
			],
			{_NotebookObject},
			TearDown :> {
				NotebookClose /@ Notebooks["Sticker Printing Output"];
				EraseObject[
					Flatten[{
						Download[Object[Transaction, ShipToECL, "Test transaction with items and containers for PrintStickers"], {ReceivedSamples[Object], ReceivedContainers[Object]}],
						Object[Transaction, ShipToECL, "Test transaction with containers only"],
						Object[Transaction, ShipToECL, "Test transaction with items and containers for PrintStickers"],
						Object[Transaction, ShipToECL, "Test transaction with items only"]
					}], Force -> True, Verbose -> True]
			},
			SetUp :> {
				Module[{sampleModel, columnModel, containerModel, sample, columnNamed, columnNoName, containerNamed, containerNoName, emptyContainer},

					sampleModel=If[!DatabaseMemberQ[Model[Sample, "Test sample model for PrintStickers"]],
						Upload[<|
							Type -> Model[Sample],
							Name -> "Test sample model for PrintStickers",
							DeveloperObject -> True
						|>]
					];

					columnModel=If[!DatabaseMemberQ[Model[Item, Column, "Test column model for PrintStickers"]],
						Upload[<|
							Type -> Model[Item, Column],
							Name -> "Test column model for PrintStickers",
							DeveloperObject -> True
						|>]
					];

					containerModel=If[!DatabaseMemberQ[Model[Container, Vessel, "Test container model for PrintStickers"]],
						Upload[<|
							Type -> Model[Container, Vessel],
							Name -> "Test container model for PrintStickers",
							DeveloperObject -> True
						|>]
					];

					sample=If[!DatabaseMemberQ[Object[Sample, "Test sample for PrintStickers"]],
						Upload[<|
							Type -> Object[Sample],
							Name -> "Test sample for PrintStickers",
							DeveloperObject -> True,
							Model -> Link[Model[Sample, "Test sample model for PrintStickers"], Objects]
						|>]
					];

					columnNamed=If[!DatabaseMemberQ[Object[Item, Column, "Test column for PrintStickers"]],
						Upload[<|
							Type -> Object[Item, Column],
							Name -> "Test column for PrintStickers",
							DeveloperObject -> True,
							Model -> Link[Model[Item, Column, "Test column model for PrintStickers"], Objects]
						|>]
					];

					columnNoName=Upload[<|
						Type -> Object[Item, Column],
						Name -> Null,
						DeveloperObject -> True,
						Model -> Link[Model[Item, Column, "Test column model for PrintStickers"], Objects]
					|>];

					containerNamed=If[!DatabaseMemberQ[Object[Container, Vessel, "Test container for PrintStickers"]],
						Upload[<|
							Type -> Object[Container, Vessel],
							Name -> "Test container for PrintStickers",
							DeveloperObject -> True,
							Model -> Link[Model[Container, Vessel, "Test container model for PrintStickers"], Objects]
						|>]
					];

					containerNoName=Upload[<|
						Type -> Object[Container, Vessel],
						Name -> Null,
						DeveloperObject -> True,
						Model -> Link[Model[Container, Vessel, "Test container model for PrintStickers"], Objects]
					|>];

					emptyContainer=Upload[<|
						Type -> Object[Container, Vessel],
						Name -> Null,
						DeveloperObject -> True,
						Model -> Link[Model[Container, Vessel, "Test container model for PrintStickers"], Objects]
					|>];

					If[!DatabaseMemberQ[Object[Transaction, ShipToECL, "Test transaction with items and containers for PrintStickers"]],
						Upload[<|
							Type -> Object[Transaction, ShipToECL],
							Name -> "Test transaction with items and containers for PrintStickers",
							DeveloperObject -> True,
							Replace[ReceivedSamples] -> {Link[sample], Link[columnNamed], Link[columnNoName]},
							Replace[ReceivedContainers] -> {Link[containerNamed], Link[containerNoName]},
							Replace[EmptyContainers] -> {Link[emptyContainer]}
						|>]
					];

					If[!DatabaseMemberQ[Object[Transaction, ShipToECL, "Test transaction with containers only"]],
						Upload[<|
							Type -> Object[Transaction, ShipToECL],
							Name -> "Test transaction with containers only",
							DeveloperObject -> True,
							Replace[ReceivedSamples] -> {Link[sample]},
							Replace[ReceivedContainers] -> {Link[containerNamed], Link[containerNoName]}
						|>]
					];

					If[!DatabaseMemberQ[Object[Transaction, ShipToECL, "Test transaction with items only"]],
						Upload[<|
							Type -> Object[Transaction, ShipToECL],
							Name -> "Test transaction with items only",
							DeveloperObject -> True,
							Replace[ReceivedSamples] -> {Link[columnNamed], Link[columnNoName]}
						|>]
					];
				]
			}
		],
		Test["Print a sticker for all containers and items shipped in a transaction (transaction with no items):",
			PrintStickers[
				Object[Transaction, ShipToECL, "Test transaction with containers only"],
				Print -> False
			],
			{_NotebookObject},
			TearDown :> {
				NotebookClose /@ Notebooks["Sticker Printing Output"];
				EraseObject[
					Flatten[{
						Download[Object[Transaction, ShipToECL, "Test transaction with items and containers for PrintStickers"], {ReceivedSamples[Object], ReceivedContainers[Object]}],
						Object[Transaction, ShipToECL, "Test transaction with containers only"],
						Object[Transaction, ShipToECL, "Test transaction with items and containers for PrintStickers"],
						Object[Transaction, ShipToECL, "Test transaction with items only"]
					}], Force -> True, Verbose -> True]
			},
			SetUp :> {
				Module[{sampleModel, columnModel, containerModel, sample, columnNamed, columnNoName, containerNamed, containerNoName, emptyContainer},

					sampleModel=If[!DatabaseMemberQ[Model[Sample, "Test sample model for PrintStickers"]],
						Upload[<|
							Type -> Model[Sample],
							Name -> "Test sample model for PrintStickers",
							DeveloperObject -> True
						|>]
					];

					columnModel=If[!DatabaseMemberQ[Model[Item, Column, "Test column model for PrintStickers"]],
						Upload[<|
							Type -> Model[Item, Column],
							Name -> "Test column model for PrintStickers",
							DeveloperObject -> True
						|>]
					];

					containerModel=If[!DatabaseMemberQ[Model[Container, Vessel, "Test container model for PrintStickers"]],
						Upload[<|
							Type -> Model[Container, Vessel],
							Name -> "Test container model for PrintStickers",
							DeveloperObject -> True
						|>]
					];

					sample=If[!DatabaseMemberQ[Object[Sample, "Test sample for PrintStickers"]],
						Upload[<|
							Type -> Object[Sample],
							Name -> "Test sample for PrintStickers",
							DeveloperObject -> True,
							Model -> Link[Model[Sample, "Test sample model for PrintStickers"], Objects]
						|>]
					];

					columnNamed=If[!DatabaseMemberQ[Object[Item, Column, "Test column for PrintStickers"]],
						Upload[<|
							Type -> Object[Item, Column],
							Name -> "Test column for PrintStickers",
							DeveloperObject -> True,
							Model -> Link[Model[Item, Column, "Test column model for PrintStickers"], Objects]
						|>]
					];

					columnNoName=Upload[<|
						Type -> Object[Item, Column],
						Name -> Null,
						DeveloperObject -> True,
						Model -> Link[Model[Item, Column, "Test column model for PrintStickers"], Objects]
					|>];

					containerNamed=If[!DatabaseMemberQ[Object[Container, Vessel, "Test container for PrintStickers"]],
						Upload[<|
							Type -> Object[Container, Vessel],
							Name -> "Test container for PrintStickers",
							DeveloperObject -> True,
							Model -> Link[Model[Container, Vessel, "Test container model for PrintStickers"], Objects]
						|>]
					];

					containerNoName=Upload[<|
						Type -> Object[Container, Vessel],
						Name -> Null,
						DeveloperObject -> True,
						Model -> Link[Model[Container, Vessel, "Test container model for PrintStickers"], Objects]
					|>];

					emptyContainer=Upload[<|
						Type -> Object[Container, Vessel],
						Name -> Null,
						DeveloperObject -> True,
						Model -> Link[Model[Container, Vessel, "Test container model for PrintStickers"], Objects]
					|>];

					If[!DatabaseMemberQ[Object[Transaction, ShipToECL, "Test transaction with items and containers for PrintStickers"]],
						Upload[<|
							Type -> Object[Transaction, ShipToECL],
							Name -> "Test transaction with items and containers for PrintStickers",
							DeveloperObject -> True,
							Replace[ReceivedSamples] -> {Link[sample], Link[columnNamed], Link[columnNoName]},
							Replace[ReceivedContainers] -> {Link[containerNamed], Link[containerNoName]},
							Replace[EmptyContainers] -> {Link[emptyContainer]}
						|>]
					];

					If[!DatabaseMemberQ[Object[Transaction, ShipToECL, "Test transaction with containers only"]],
						Upload[<|
							Type -> Object[Transaction, ShipToECL],
							Name -> "Test transaction with containers only",
							DeveloperObject -> True,
							Replace[ReceivedSamples] -> {Link[sample]},
							Replace[ReceivedContainers] -> {Link[containerNamed], Link[containerNoName]}
						|>]
					];

					If[!DatabaseMemberQ[Object[Transaction, ShipToECL, "Test transaction with items only"]],
						Upload[<|
							Type -> Object[Transaction, ShipToECL],
							Name -> "Test transaction with items only",
							DeveloperObject -> True,
							Replace[ReceivedSamples] -> {Link[columnNamed], Link[columnNoName]}
						|>]
					];
				]
			}
		],
		Example[
			{Additional, "Print destination stickers for all positions in input:"},
			PrintStickers[
				Object[Container, Plate, "id:M8n3rxYAoe1R"],
				All,
				Print -> False
			],
			{_NotebookObject..},
			TearDown :> {
				NotebookClose /@ Notebooks["Sticker Printing Output"]
			}
		],

		Example[
			{Additional, "Specify the particular position names for which Destination stickers should be printed:"},
			PrintStickers[
				Object[Container, Plate, "id:M8n3rxYAoe1R"],
				{"A1", "B2"},
				Print -> False
			],
			{_NotebookObject},
			TearDown :> {
				NotebookClose /@ Notebooks["Sticker Printing Output"]
			}
		],

		Example[
			{Additional, "Print a sticker for a plumbing connector:"},
			PrintStickers[
				Object[Plumbing, Tubing, "Print Stickers Test Object Plumbing for Plumbing Destination"],
				{"Test Port"},
				Print -> False
			],
			{_NotebookObject},
			SetUp :> {
				Module[
					{objsInDbStickers, modl},
					objsInDbStickers={
						Model[Plumbing, Tubing, "Print Stickers Test Model Plumbing for Plumbing Destination"],
						Object[Plumbing, Tubing, "Print Stickers Test Object Plumbing for Plumbing Destination"]
					};
					EraseObject[
						PickList[objsInDbStickers, DatabaseMemberQ[objsInDbStickers]],
						Force -> True,
						Verbose -> False
					];
					modl=Upload[
						<|
							Type -> Model[Plumbing, Tubing],
							Name -> "Print Stickers Test Model Plumbing for Plumbing Destination",
							Replace[Connectors] -> {{"Test Port", Threaded, None, 0.25 * Inch, 0.125 * Inch, Male}}
						|>
					];
					Upload[
						<|
							Type -> Object[Plumbing, Tubing],
							Name -> "Print Stickers Test Object Plumbing for Plumbing Destination",
							Model -> Link[modl, Objects]
						|>
					];
				]
			},
			TearDown :> {
				NotebookClose /@ Notebooks["Sticker Printing Output"];
				Module[
					{objsInDbStickers},
					objsInDbStickers={
						Model[Plumbing, Tubing, "Print Stickers Test Model Plumbing for Plumbing Destination"],
						Object[Plumbing, Tubing, "Print Stickers Test Object Plumbing for Plumbing Destination"]
					};
					EraseObject[
						PickList[objsInDbStickers, DatabaseMemberQ[objsInDbStickers]],
						Force -> True,
						Verbose -> False
					]
				]
			}
		],

		Example[
			{Additional, "Print a sticker for a wiring connector:"},
			PrintStickers[
				Object[Wiring, "Print Stickers Test Object Wiring for Wiring Destination"],
				{"Test Wiring Connector"},
				Print -> False
			],
			{_NotebookObject},
			SetUp :> {
				Module[
					{objsInDbStickers, modl},
					objsInDbStickers={
						Model[Wiring, "Print Stickers Test Model Wiring for Wiring Destination"],
						Object[Wiring, "Print Stickers Test Object Wiring for Wiring Destination"]
					};
					EraseObject[
						PickList[objsInDbStickers, DatabaseMemberQ[objsInDbStickers]],
						Force -> True,
						Verbose -> False
					];
					modl=Upload[
						<|
							Type -> Model[Wiring],
							Name -> "Print Stickers Test Model Wiring for Wiring Destination",
							Replace[WiringConnectors] -> {{"Test Wiring Connector", ElectraSynElectrodePushPlug, Male}}
						|>
					];
					Upload[
						<|
							Type -> Object[Wiring],
							Name -> "Print Stickers Test Object Wiring for Wiring Destination",
							Model -> Link[modl, Objects]
						|>
					];
				]
			},
			TearDown :> {
				NotebookClose /@ Notebooks["Sticker Printing Output"];
				Module[
					{objsInDbStickers},
					objsInDbStickers={
						Model[Wiring, "Print Stickers Test Model Wiring for Wiring Destination"],
						Object[Wiring, "Print Stickers Test Object Wiring for Wiring Destination"]
					};
					EraseObject[
						PickList[objsInDbStickers, DatabaseMemberQ[objsInDbStickers]],
						Force -> True,
						Verbose -> False
					]
				]
			}
		],

		Example[
			{Additional, "If a singleton position is specified, it will be expanded to index-match inputs:"},
			PrintStickers[
				{Object[Container, Plate, "id:M8n3rxYAoe1R"], Object[Container, Plate, "id:M8n3rxYAoe1R"]},
				"A1",
				Print -> False
			],
			{_NotebookObject},
			TearDown :> {
				NotebookClose /@ Notebooks["Sticker Printing Output"]
			}
		],

		Example[
			{Additional, "If a flat list of positions is specified, it will be repeated to index-match inputs:"},
			PrintStickers[
				{Object[Container, Plate, "id:M8n3rxYAoe1R"], Object[Container, Plate, "id:M8n3rxYAoe1R"]},
				{"A1", "B1"},
				Print -> False
			],
			{_NotebookObject},
			TearDown :> {
				NotebookClose /@ Notebooks["Sticker Printing Output"]
			}
		],

		Example[
			{Additional, "If an input-index-matched list of positions is specified, it will be used as-is:"},
			PrintStickers[
				{Object[Container, Plate, "id:M8n3rxYAoe1R"], Object[Container, Plate, "id:M8n3rxYAoe1R"]},
				{{"A1", "B1"}, {"C1", "D1"}},
				Print -> False
			],
			{_NotebookObject},
			TearDown :> {
				NotebookClose /@ Notebooks["Sticker Printing Output"]
			}
		],
		Example[
			{Additional, "Print stickers for a single raw ID:"},
			id1=CreateID[];
			PrintStickers[
				id1,
				Print -> False
			],
			{_NotebookObject},
			TearDown :> {
				NotebookClose /@ Notebooks["Sticker Printing Output"]
			},
			Variables :> {id1}
		],
		Example[
			{Additional, "Print stickers for a list of raw IDs:"},
			{id1, id2, id3}=CreateID[3];
			PrintStickers[
				{id1, id2, id3},
				Print -> False
			],
			{_NotebookObject},
			TearDown :> {
				NotebookClose /@ Notebooks["Sticker Printing Output"]
			},
			Variables :> {id1, id2, id3}
		],


		(* --- Options --- *)

		Example[
			{Options, StickerSize, "Specify the size of sticker to be used:"},
			PrintStickers[
				Object[Sample, "id:kEJ9mqa154dV"],
				StickerSize -> Large,
				Print -> False
			],
			{_NotebookObject},
			TearDown :> {
				NotebookClose /@ Notebooks["Sticker Printing Output"]
			}
		],

		Example[{Options,StickerSize,"Specify the size of a sticker to be Piggyback:"},
		    PrintStickers[
				Object[Sample, "id:kEJ9mqa154dV"],
				StickerSize -> Piggyback,
				Print -> False
			],
			{_NotebookObject},
			TearDown :> {
				NotebookClose /@ Notebooks["Sticker Printing Output"]
			}
		],


		Example[
			{Options, StickerModel, "Specify the particular Model[Item,Sticker] on which stickers should be printed:"},
			PrintStickers[
				Object[Sample, "id:kEJ9mqa154dV"],
				StickerModel -> Model[Item, Sticker, "id:mnk9jO3dexZY"],
				Print -> False
			],
			{_NotebookObject},
			TearDown :> {
				NotebookClose /@ Notebooks["Sticker Printing Output"]
			}
		],

		Example[
			{Options, Print, "Specify that sticker sheets should be returned rather than printed using the Print option:"},
			PrintStickers[
				Object[Sample, "id:kEJ9mqa154dV"],
				Print -> False
			],
			{_NotebookObject}
		],
		Example[
			{Options, TextScaling, "Switch between Cropping and Scaling of description text that is too long to fit on the specified stickers:"},
			PrintStickers[
				Object[Sample, "id:kEJ9mqa154dV"],
				TextScaling -> Crop,
				Print -> False
			],
			{_NotebookObject},
			TearDown :> {
				NotebookClose /@ Notebooks["Sticker Printing Output"]
			}
		],

		Example[
			{Options, Border, "Specify whether the border delineating the edge of the sticker graphic's area should be drawn:"},
			PrintStickers[
				Object[Sample, "id:kEJ9mqa154dV"],
				Border -> True,
				Print -> False
			],
			{_NotebookObject},
			TearDown :> {
				NotebookClose /@ Notebooks["Sticker Printing Output"]
			}
		],


		(* --- Messages --- *)

		Example[
			{Messages, "InvalidObjects", "Invalid SLL Object(s) passed into the function will produce an error:"},
			PrintStickers[Object[Sample, "id:NonexistentSample"]],
			$Failed,
			Messages :> {PrintStickers::InvalidObjects}
		],
		Example[
			{Messages, "NoDestinations", "Attempting to print Destination stickers for an item that is not a Container or Instrument will produce an error:"},
			PrintStickers[Object[Sample, "id:kEJ9mqa154dV"], All],
			$Failed,
			Messages :> {PrintStickers::NoDestinations}
		],
		Example[
			{Messages, "StickerModelSizeMismatch", "Specifying a StickerSize that does not match the size of the specified StickerModel will produce an error:"},
			PrintStickers[
				Object[Sample, "id:kEJ9mqa154dV"],
				StickerSize -> Small,
				StickerModel -> Model[Item, Sticker, "id:BYDOjv15qNZX"]
			],
			$Failed,
			Messages :> {PrintStickers::StickerModelSizeMismatch}
		],
		Example[
			{Messages, "InputDimensionMismatch", "Specifying a Positions input that does not index-match sticker input will produce an error:"},
			PrintStickers[Object[Container, Plate, "id:M8n3rxYAoe1R"], {{"A1"}, {"B2"}}],
			$Failed,
			Messages :> {PrintStickers::InputDimensionMismatch}
		],
		Example[
			{Messages, "InvalidDestinations", "Specifying a Position that does not exist in the given input object will produce an error:"},
			PrintStickers[
				Object[Container, Deck, "Print Stickers Test Deck"],
				{"Incorrect Test Location"},
				Print -> False
			],
			$Failed,
			Messages :> {PrintStickers::InvalidDestinations},
			SetUp :> {
				Module[
					{objsInDbStickers, modl},
					objsInDbStickers={
						Model[Container, Deck, "Print Stickers Test Model Deck"],
						Object[Container, Deck, "Print Stickers Test Deck"]
					};
					EraseObject[
						PickList[objsInDbStickers, DatabaseMemberQ[objsInDbStickers]],
						Force -> True,
						Verbose -> False
					];
					modl=Upload[
						<|
							Type -> Model[Container, Deck],
							Name -> "Print Stickers Test Model Deck",
							Replace[Positions] -> {<|Name -> "Fake Reservoir Slot", Footprint -> Open, MaxWidth -> 1Meter, MaxDepth -> 1Meter, MaxHeight -> Null|>}
						|>
					];
					Upload[
						<|
							Type -> Object[Container, Deck],
							Name -> "Print Stickers Test Deck",
							Model -> Link[modl, Objects]
						|>
					];
				]
			},
			TearDown :> {
				Module[
					{objsInDbStickers},
					objsInDbStickers={
						Model[Container, Deck, "Print Stickers Test Model Deck"],
						Object[Container, Deck, "Print Stickers Test Deck"]
					};
					EraseObject[
						PickList[objsInDbStickers, DatabaseMemberQ[objsInDbStickers]],
						Force -> True,
						Verbose -> False
					]
				]
			}
		],
		Example[{Messages,"StickerSizeTypeMismatch","Specifying a Piggyback StickerSize and Destination StickerType will produce an error:"},
		    PrintStickers[
				Object[Container, Plate, "id:M8n3rxYAoe1R"],
				{{"A1"}, {"B2"}},
				StickerSize -> Piggyback
			],
		    $Failed,
		    Messages :> {PrintStickers::StickerSizeTypeMismatch}
		],

		Test[
			"Won't print stickers for a plumbing connector the item doesn't have a connector for:",
			PrintStickers[
				Object[Plumbing, Tubing, "Print Stickers Test Object Plumbing for Plumbing Destination"],
				{"Incorrect Test Port"},
				Print -> False
			],
			$Failed,
			Messages :> {PrintStickers::InvalidDestinations},
			SetUp :> {
				Module[
					{objsInDbStickers, modl},
					objsInDbStickers={
						Model[Plumbing, Tubing, "Print Stickers Test Model Plumbing for Plumbing Destination"],
						Object[Plumbing, Tubing, "Print Stickers Test Object Plumbing for Plumbing Destination"]
					};
					EraseObject[
						PickList[objsInDbStickers, DatabaseMemberQ[objsInDbStickers]],
						Force -> True,
						Verbose -> False
					];
					modl=Upload[
						<|
							Type -> Model[Plumbing, Tubing],
							Name -> "Print Stickers Test Model Plumbing for Plumbing Destination",
							Replace[Connectors] -> {{"Test Port", Threaded, None, 0.25 * Inch, 0.125 * Inch, Male}}
						|>
					];
					Upload[
						<|
							Type -> Object[Plumbing, Tubing],
							Name -> "Print Stickers Test Object Plumbing for Plumbing Destination",
							Model -> Link[modl, Objects]
						|>
					];
				]
			},
			TearDown :> {
				Module[
					{objsInDbStickers},
					objsInDbStickers={
						Model[Plumbing, Tubing, "Print Stickers Test Model Plumbing for Plumbing Destination"],
						Object[Plumbing, Tubing, "Print Stickers Test Object Plumbing for Plumbing Destination"]
					};
					EraseObject[
						PickList[objsInDbStickers, DatabaseMemberQ[objsInDbStickers]],
						Force -> True,
						Verbose -> False
					]
				]
			}
		],
		Test[
			"Won't print stickers for a wiring connector the item doesn't have a wiring connector for:",
			PrintStickers[
				Object[Wiring, "Print Stickers Test Object Wiring for Wiring Destination"],
				{"Incorrect Test Port"},
				Print -> False
			],
			$Failed,
			Messages :> {PrintStickers::InvalidDestinations},
			SetUp :> {
				Module[
					{objsInDbStickers, modl},
					objsInDbStickers={
						Model[Wiring, "Print Stickers Test Model Wiring for Wiring Destination"],
						Object[Wiring, "Print Stickers Test Object Wiring for Wiring Destination"]
					};
					EraseObject[
						PickList[objsInDbStickers, DatabaseMemberQ[objsInDbStickers]],
						Force -> True,
						Verbose -> False
					];
					modl=Upload[
						<|
							Type -> Model[Wiring],
							Name -> "Print Stickers Test Model Wiring for Wiring Destination",
							Replace[WiringConnectors] -> {{"Test Wiring Connector", ElectraSynElectrodePushPlug, Male}}
						|>
					];
					Upload[
						<|
							Type -> Object[Wiring],
							Name -> "Print Stickers Test Object Wiring for Wiring Destination",
							Model -> Link[modl, Objects]
						|>
					];
				]
			},
			TearDown :> {
				Module[
					{objsInDbStickers},
					objsInDbStickers={
						Model[Wiring, "Print Stickers Test Model Wiring for Wiring Destination"],
						Object[Wiring, "Print Stickers Test Object Wiring for Wiring Destination"]
					};
					EraseObject[
						PickList[objsInDbStickers, DatabaseMemberQ[objsInDbStickers]],
						Force -> True,
						Verbose -> False
					]
				]
			}
		]
	},
	Stubs :> {},
	Skip -> "File Server"
];



(* ::Subsubsection::Closed:: *)
(*printStickersCore*)


DefineTests[
	printStickersCore,
	{
		Example[
			{Basic, "Print stickers from low-level string input:"},
			printStickersCore[
				{"id:ScrewThePatriots"},
				{"id:ScrewThePatriots"},
				{{"Tom Brady is a Cheaty McCheaterson", "id:PatsSuck", "Object[Sample, DeflatedFootball]"}},
				resolvedOps
			],
			{_NotebookObject},
			TearDown :> {
				NotebookClose /@ Notebooks["Sticker Printing Output"]
			},
			Stubs :> {
				resolvedOps={
					StickerSize -> Small,
					StickerModel -> Download[Model[Item, Sticker, "id:mnk9jO3dexZY"]],
					Print -> False,
					TextScaling -> Scale,
					Border -> False,
					FontFamily -> "Bitstream Vera Sans Mono",
					FastTrack -> False,
					Interactive -> False,
					Cache -> {}
				}
			}
		]
	}
];



(* ::Subsubsection::Closed:: *)
(*assembleObjectStickerInformation*)


DefineTests[
	assembleStickerInformation,
	{
		Test[
			"Assemble object sticker text and barcode for a container:",
			assembleStickerInformation[
				objectPackets,
				modelPackets
			],
			{
				{"id:M8n3rxYAoe1R"},
				{
					{"43 Task", "Centrifuge test 2mL plate with one sample", "id:M8n3rxYAoe1R"}
				}
			}
		],
		Test[
			"Assemble destination sticker text and barcode for all positions in a container:",
			assembleStickerInformation[
				objectPackets,
				modelPackets,
				All
			],
			{
				{Repeated[_String, {96}]},
				{Repeated[_String, {96}]},
				{Repeated[{Repeated[_String, {3}]}, {96}]}
			}
		],
		Test[
			"Assemble destination sticker text for only a specified subset of positions in a container:",
			assembleStickerInformation[
				objectPackets,
				modelPackets,
				{{"A1", "A2"}}
			],
			{
				{Repeated[_String, {2}]},
				{Repeated[_String, {2}]},
				{Repeated[{Repeated[_String, {3}]}, {2}]}
			}
		],
		Test[
			"Destination stickers printed for VLM racks have position name on the bottom line so that it is close to the barcode, while other objects have position name on the top line:",
			assembleStickerInformation[
				Join[objectPackets, rackObjectPackets],
				Join[modelPackets, rackModelPackets],
				{{"A1"}, {"A1", "B1"}}
			],
			{
				{Repeated[_String, {3}]},
				{Repeated[_String, {3}]},
				{
					{"43 Task", "A1", "id:M8n3rxYAoe1R"},
					{"A1", "id:WNa4ZjRrk7LD", "65 Sean"},
					{"B1", "id:WNa4ZjRrk7LD", "65 Sean"}
				}
			}
		]
	},
	SetUp :> {
		{objectPackets, modelPackets, rackObjectPackets, rackModelPackets}=Download[{
			{Object[Container, Plate, "id:M8n3rxYAoe1R"]},
			{Model[Container, Plate, "id:L8kPEjkmLbvW"]},
			{Object[Container, Rack, "id:WNa4ZjRrk7LD"]},
			{Model[Container, Rack, "id:7X104vK9ZZap"]}
		}]
	},
	TearDown :> {
		Clear[objectPackets, modelPackets, rackObjectPackets, rackModelPackets]
	}
];


(* ::Subsubsection::Closed:: *)
(*resolvePrintStickersOptions*)


DefineTests[
	resolvePrintStickersOptions,
	{
		Test[
			"Resolve options for a test container list:",
			resolvePrintStickersOptions[testCtrList, stickerModels, Object, optDefaults],
			{
				StickerSize -> Small,
				StickerModel -> KeyValuePattern[Object -> Model[Item, Sticker, "id:mnk9jO3dexZY"]],
				Print -> True,
				TextScaling -> Scale,
				Border -> False,
				FontFamily -> "Bitstream Vera Sans Mono",
				Output -> Notebook,
				Interactive -> False,
				FastTrack -> False,
				Upload -> True,
				Cache -> {}
			}
		],
		Test[
			"StickerSize defaults to Small if neither StickerSize nor StickerModel have been specified:",
			StickerSize /. resolvePrintStickersOptions[testCtrList, stickerModels, Object, optDefaults],
			Small
		],
		Test[
			"StickerSize value is passed through as specified if StickerModel has not been specified:",
			StickerSize /. resolvePrintStickersOptions[testCtrList, stickerModels, Object, opsList],
			Large,
			Stubs :> {
				opsList=ReplaceRule[optDefaults, StickerSize -> Large]
			}
		],
		Test[
			"StickerSize defaults appropriately if StickerSize->Automatic and StickerModel has been specified:",
			StickerSize /. resolvePrintStickersOptions[testCtrList, stickerModels, Object, opsList],
			Large,
			Stubs :> {
				opsList=ReplaceRule[optDefaults, StickerModel -> Model[Item, Sticker, "id:BYDOjv15qNZX"]]
			}
		],
		Test[
			"If both StickerModel and StickerSize have been specified, throw an error if they conflict:",
			resolvePrintStickersOptions[testCtrList, stickerModels, Object, opsList],
			$Failed,
			Messages :> {PrintStickers::StickerModelSizeMismatch},
			Stubs :> {
				opsList=ReplaceRule[optDefaults, {StickerSize -> Small, StickerModel -> Model[Item, Sticker, "id:BYDOjv15qNZX"]}]
			}
		],
		Test[
			"If StickerModel has been specified, it is returned as-is:",
			StickerModel /. resolvePrintStickersOptions[testCtrList, stickerModels, Object, opsList],
			KeyValuePattern[Object -> Model[Item, Sticker, "id:mnk9jO3dexZY"]],
			Stubs :> {
				opsList=ReplaceRule[optDefaults, StickerModel -> Model[Item, Sticker, "id:mnk9jO3dexZY"]]
			}
		],
		Test[
			"If StickerModel->Automatic, it is resolved appropriately based on sticker type input and StickerSize option:",
			StickerModel /. resolvePrintStickersOptions[testCtrList, stickerModels, Object, opsList],
			KeyValuePattern[Object -> Model[Item, Sticker, "id:mnk9jO3dexZY"]],
			Stubs :> {
				opsList=ReplaceRule[optDefaults, {StickerSize -> Small}]
			}
		],
		Test[
			"If StickerModel->Automatic, it is resolved appropriately based on sticker type input and StickerSize options:",
			StickerModel /. resolvePrintStickersOptions[testCtrList, stickerModels, Object, opsList],
			KeyValuePattern[Object -> Model[Item, Sticker, "id:BYDOjv15qNZX"]],
			Stubs :> {
				opsList=ReplaceRule[optDefaults, {StickerSize -> Large}]
			}
		],
		Test[
			"If StickerModel->Automatic, it is resolved appropriately based on sticker type input and StickerSize options:",
			StickerModel /. resolvePrintStickersOptions[testCtrList, stickerModels, Destination, opsList],
			KeyValuePattern[Object -> Model[Item, Sticker, "id:M8n3rxYAklam"]],
			Stubs :> {
				opsList=ReplaceRule[optDefaults, {StickerSize -> Small}]
			}
		],
		Test[
			"If StickerModel->Automatic, it is resolved appropriately based on StickerType and StickerSize options:",
			StickerModel /. resolvePrintStickersOptions[testCtrList, stickerModels, Destination, opsList],
			KeyValuePattern[Object -> Model[Item, Sticker, "id:WNa4ZjRDwv1V"]],
			Stubs :> {
				opsList=ReplaceRule[optDefaults, {StickerSize -> Large}]
			}
		],
		Test[
			"If StickerModel->Automatic, it is resolved appropriately if StickerSize is Piggyback:",
			StickerModel /. resolvePrintStickersOptions[testCtrList, stickerModels, Object, opsList],
			KeyValuePattern[Name -> "2in x 0.5in Piggyback Object Label with DataMatrix Barcode"],
			Stubs :> {
				opsList=ReplaceRule[optDefaults, {StickerSize -> Piggyback}]
			}
		],
		Test[
			"If StickerSize is Piggyback and StickerType is Destination, throw an error and return $Failed:",
			resolvePrintStickersOptions[testCtrList, stickerModels, Destination, opsList],
			$Failed,
			Messages :> {PrintStickers::StickerSizeTypeMismatch},
			Stubs :> {
				opsList=ReplaceRule[optDefaults, {StickerSize -> Piggyback}]
			}
		],
		Test[
			"If the StickerSize of the given StickerModel is Piggyback and StickerType is Destination, throw an error and return $Failed:",
			resolvePrintStickersOptions[testCtrList, stickerModels, Destination, opsList],
			$Failed,
			Messages :> {PrintStickers::StickerSizeTypeMismatch},
			Stubs :> {
				opsList=ReplaceRule[optDefaults, {StickerModel -> Model[Item, Sticker, "2in x 0.5in Piggyback Object Label with DataMatrix Barcode"]}]
			}
		]
	},
	Stubs :> {
		testCtrList={Object[Container, Plate, "id:M8n3rxYAoe1R"]},
		optDefaults=SafeOptions[PrintStickers],
		stickerModels=Download[Search[Model[Item, Sticker], DeveloperObject != True && Deprecated != True]]
	}
];


(* ::Subsubsection::Closed:: *)
(*drawSticker*)


DefineTests[
	drawSticker,
	{
		Test[
			"Draw a small Object sticker:",
			drawSticker[
				Model[Container, Vessel, "50mL Tube"],
				barcodeText,
				stickerText,
				optionsModel1
			],
			ValidGraphicsP[]
		],
		Test[
			"Draw a large Object sticker:",
			drawSticker[
				Model[Container, Vessel, "50mL Tube"],
				barcodeText,
				stickerText,
				optionsModel2
			],
			ValidGraphicsP[]
		],
		Test[
			"Draw a small Destination sticker:",
			drawSticker[
				Model[Container, Vessel, "50mL Tube"],
				barcodeText,
				stickerText,
				optionsModel3
			],
			ValidGraphicsP[]
		],
		Test[
			"Draw a large Destination sticker:",
			drawSticker[
				Model[Container, Vessel, "50mL Tube"],
				barcodeText,
				stickerText,
				optionsModel4
			],
			ValidGraphicsP[]
		],
		Test[
			"Draw a sticker on which excessively long text is cropped rather than scaled:",
			drawSticker[
				Model[Container, Vessel, "50mL Tube"],
				barcodeText,
				stickerText,
				optionsCrop
			],
			ValidGraphicsP[]
		]
	},
	Stubs :> {
		barcodeText="id:asdfghjkl",
		stickerText={"line1", "line2", "line3 is way too long and will definitely have to be scaled or cropped"},
		optDefaults=SafeOptions[drawSticker],
		optionsModel1=ReplaceRule[optDefaults, StickerModel -> Download[Model[Item, Sticker, "id:mnk9jO3dexZY"]]],
		optionsModel2=ReplaceRule[optDefaults, StickerModel -> Download[Model[Item, Sticker, "id:BYDOjv15qNZX"]]],
		optionsModel3=ReplaceRule[optDefaults, StickerModel -> Download[Model[Item, Sticker, "id:M8n3rxYAklam"]]],
		optionsModel4=ReplaceRule[optDefaults, StickerModel -> Download[Model[Item, Sticker, "id:WNa4ZjRDwv1V"]]],
		optionsCrop=ReplaceRule[
			optDefaults,
			{
				TextScaling -> Crop,
				StickerModel -> Download[Model[Item, Sticker, "id:mnk9jO3dexZY"]]
			}
		]
	}
];


(* ::Subsubsection::Closed:: *)
(*generateBarcodeInset*)


DefineTests[
	generateBarcodeInset,
	{
		Test[
			"Generate an inset containing the specified barcode at the specified size and relative position:",
			generateBarcodeInset[
				barcodeImg,
				{0, 0},
				{10, 10}
			],
			Inset[_, {0, 0}, _, {10, 10}]
		]
	},
	Stubs :> {
		barcodeImg=Constellation`Private`importCloudFile[EmeraldCloudFile["AmazonS3", "emeraldsci-ecl-blobstore-stage", "454fdca385c9f3e80e73dbf496326fb9.jpg"]]
	}
];


(* ::Subsubsection::Closed:: *)
(*encodeDataMatrix*)


DefineTests[
	encodeDataMatrix,
	{
		Test[
			"Encode a DataMatrix code of whatever aspect ratio makes the most sense:",
			encodeDataMatrix["id:asdfghjkl"],
			_Image
		],
		Test[
			"Encode a DataMatrix code with square aspect ratio:",
			encodeDataMatrix["id:asdfghjkl", Automatic, Automatic, "Square"],
			_Image?((Divide @@ ImageDimensions[#]) == 1&)
		],
		Test[
			"Encode a DataMatrix code with rectangular aspect ratio:",
			encodeDataMatrix["id:qwerty", Automatic, Automatic, "Rectangle"],
			_Image?((Divide @@ ImageDimensions[#]) > 1&)
		],
		Test[
			"Encode a DataMatrix code with rectangular aspect ratio:",
			encodeDataMatrix["id:qwerty", Automatic, Automatic, "Rectangle"],
			_Image?((Divide @@ ImageDimensions[#]) > 1&)
		],
		Test[
			"Encode a DataMatrix code with a minimum specified size:",
			encodeDataMatrix["id:qwerty", {16, 16}, Automatic, Automatic],
			_Image?(Min[ImageDimensions[#]] == 16&)
		],
		Test[
			"Encode a DataMatrix code with a maximum specified size:",
			encodeDataMatrix["id:qwerty", {16, 16}, Automatic, Automatic],
			_Image?(Max[ImageDimensions[#]] == 16&)
		],
		Test[
			"If the specified maximum dimensions are too small to encode the specified text, a message is displayed and $Failed is returned:",
			encodeDataMatrix["id:qwerty", Automatic, {8, 8}, Automatic],
			$Failed,
			Messages :> {JLink`Java::excptn}
		]
	}
];


(* ::Subsubsection::Closed:: *)
(*assembleStickerSheets*)


DefineTests[
	assembleStickerSheets,
	{
		Test[
			"Assemble a single sheet worth of stickers:",
			assembleStickerSheets[singleSheetOfStickers, 10, testOps],
			{ValidGraphicsP[]}
		],
		Test[
			"Assemble multiple sheets worth of stickers:",
			assembleStickerSheets[multipleSheetsOfStickers, 10, testOps],
			{Repeated[ValidGraphicsP[], {2}]}
		]
	},
	Stubs :> {
		CreateDocument[gfx_Graphics, ___]:=gfx,

		testOps={
			StickerSize -> Small,
			StickerModel -> Download[Model[Item, Sticker, "id:mnk9jO3dexZY"]],
			Print -> False,
			TextScaling -> Scale,
			Border -> False,
			Cache -> {},
			FastTrack -> False,
			FontFamily -> "Consolas"
		},

		singleStickerGraphic=drawSticker[
			Model[Container, Vessel, "50mL Tube"],
			"id:asdfghjkl",
			{"line1", "line2", "line3"},
			testOps
		],

		singleSheetOfStickers=Repeat[singleStickerGraphic, 5],
		multipleSheetsOfStickers=Repeat[singleStickerGraphic, 15]
	}
];


(* ::Subsubsection::Closed:: *)
(*generateNumberAndWord*)

DefineTests[
	generateNumberAndWord,
	{
		Example[{Basic, "Generate a hashphrase for an object ID:"},
			generateNumberAndWord["id:dORYzZRZlZAR"],
			"62 Berkeley"
		],
		Example[{Basic, "Generate hashphrases for multiple object IDs:"},
			generateNumberAndWord[
				{
					"id:dORYzZRZlZAR", "id:eGakldadLdre", "id:pZx9joxoroW0",
					"id:4pO6dMOM7Mxo", "id:Vrbp1jbjZjxx", "id:XnlV5jljejx8",
					"id:qdkmxzkzbzWa", "id:R8e1Pjej7jxK", "id:O81aEB1B7Boe",
					"id:GmzlKjzj7jB9"
				}
			],
			{
				"62 Berkeley", "35 Fantastic", "14 Awesome",
				"11 Author", "70 Belgium", "95 Seven",
				"73 Hole", "47 Yesterday", "87 Limit",
				"41 Dating"
			}
		],
		Example[{Additional, "Leading whitespace is ignored:"},
			generateNumberAndWord[" id:dORYzZRZlZAR"],
			"62 Berkeley"
		],
		Example[{Additional, "Trailing whitespace is ignored:"},
			generateNumberAndWord["id:dORYzZRZlZAR "],
			"62 Berkeley"
		],
		Example[{Additional, "Leading and trailing whitespace is ignored:"},
			generateNumberAndWord["  id:dORYzZRZlZAR 	"],
			"62 Berkeley"
		],
		Example[{Additional, "Trailing position designations are ignored:"},
			generateNumberAndWord["id:dORYzZRZlZAR[A1]"],
			"62 Berkeley"
		],
		Example[{Additional, "Trailing position designations are ignored 2:"},
			generateNumberAndWord["id:dORYzZRZlZAR[Test Position]"],
			"62 Berkeley"
		],
		Example[{Additional, "Whitespace and position designations are handled together:"},
			generateNumberAndWord["id:dORYzZRZlZAR[Test Position] "],
			"62 Berkeley"
		],
		Example[{Additional, "Whitespace and positions are handled in the listable overload:"},
			generateNumberAndWord[
				{
					"id:dORYzZRZlZAR ", " id:eGakldadLdre", "   id:pZx9joxoroW0",
					"id:4pO6dMOM7Mxo  ", "	id:Vrbp1jbjZjxx", "	id:XnlV5jljejx8	",
					"id:qdkmxzkzbzWa[A1]", "id:R8e1Pjej7jxK[A1] ", "id:O81aEB1B7Boe[Test Position]",
					"id:GmzlKjzj7jB9"
				}
			],
			{
				"62 Berkeley", "35 Fantastic", "14 Awesome",
				"11 Author", "70 Belgium", "95 Seven",
				"73 Hole", "47 Yesterday", "87 Limit",
				"41 Dating"
			}
		],
		Example[{Messages, "MalformedInput", "Malformed IDs throw an error:"},
			generateNumberAndWord["id:dORYzZRZlZAR!"],
			$Failed,
			Messages :> {generateNumberAndWord::MalformedInput}
		],
		Example[{Messages, "MalformedInput", "Full object references throw an error:"},
			generateNumberAndWord[Object[Container, Vessel, "id:dORYzZRZlZAR"]],
			$Failed,
			Messages :> {generateNumberAndWord::MalformedInput}
		],
		Example[{Messages, "MalformedInput", "Throws an error if any item of a list of inputs is invalid and returns $Failed for that item:"},
			generateNumberAndWord[
				{
					"id:dORYzZRZlZAR",
					Object[Container, Vessel, "id:dORYzZRZlZAR!"],
					"id:pZx9joxoroW0"
				}
			],
			{
				"62 Berkeley",
				$Failed,
				"14 Awesome"
			},
			Messages :> {generateNumberAndWord::MalformedInput}
		]
	}
];