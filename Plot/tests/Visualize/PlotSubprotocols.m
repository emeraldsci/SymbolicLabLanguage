(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*PlotSubprotocols*)


DefineTests[PlotSubprotocols,
	{
		Example[{Basic,"Creates a graph showing the subprotocol workflow:"},
			PlotSubprotocols[
				Object[Protocol, HPLC, "HPLC protocol 1 for PlotSubprotocols tests"<>$SessionUUID]
			],
			_Graph
		],

		(* different color coding *)
		Example[{Basic,"Creates a graph showing the subprotocol workflow with color coding for OperationStatus:"},
			PlotSubprotocols[
				Object[Protocol, HPLC, "HPLC protocol 1 for PlotSubprotocols tests"<>$SessionUUID]
			],
			_Graph
		],

		(* subprotocol *)
		Example[{Basic,"Works for subprotocols as well as parent protocols:"},
			PlotSubprotocols[
				Object[Protocol, StockSolution, "StockSolution protocol 2 for PlotSubprotocols tests"<>$SessionUUID]
			],
			_Graph
		],

		(* -- Options -- *)
		Example[{Options,GraphLayout,"Create a table showing the subprotocol workflow with color coding for Status and OperationStatus:"},
			{
				PlotSubprotocols[
					Object[Protocol, HPLC, "HPLC protocol 1 for PlotSubprotocols tests"<>$SessionUUID],
					Output -> Table
				],
				PlotSubprotocols[
					Object[Protocol, ManualSamplePreparation, "ManualSamplePreparation protocol 2 for PlotSubprotocols tests"<>$SessionUUID],
					Output -> Table
				],
				PlotSubprotocols[
					Object[Protocol, ManualSamplePreparation, "ManualSamplePreparation protocol 3 for PlotSubprotocols tests"<>$SessionUUID],
					Output -> Table
				],
				PlotSubprotocols[
					Object[Protocol, ManualSamplePreparation, "ManualSamplePreparation protocol 4 for PlotSubprotocols tests"<>$SessionUUID],
					Output -> Table
				]
			},
			{_Pane, _Pane, _Pane, _Pane}
		],
		Example[{Options,Output,"Output -> List returns a list of all samples into which the parent sample was transferred either directly or indirectly:"},
			PlotSubprotocols[
				Object[Protocol, HPLC, "HPLC protocol 1 for PlotSubprotocols tests"<>$SessionUUID],
				Output -> Table
			],
			_Pane
		],
		Example[{Options,Output,"Output -> Association returns rules representing the workflow:"},
			PlotSubprotocols[
				Object[Protocol, HPLC, "HPLC protocol 1 for PlotSubprotocols tests"<>$SessionUUID],
				Output -> Association
			],
			{_Rule..}
		],
		Example[{Options,Output,"Output -> All returns both the Table and Graph output:"},
			PlotSubprotocols[
				Object[Protocol, HPLC, "HPLC protocol 1 for PlotSubprotocols tests"<>$SessionUUID],
				Output -> All
			],
			_TableForm
		],
		Example[{Options,ColorFunction,"Set the graphic color coding to use either Status or OperationStatus:"},
			{
				PlotSubprotocols[
					Object[Protocol, HPLC, "HPLC protocol 1 for PlotSubprotocols tests"<>$SessionUUID],
					ColorFunction -> Status
				],
				PlotSubprotocols[
					Object[Protocol, HPLC, "HPLC protocol 1 for PlotSubprotocols tests"<>$SessionUUID],
					ColorFunction -> OperationStatus
				]
			},
			{_Graph, _Graph}
		],

		(* -- Messages -- *)
		Example[{Messages,"NoSubprotocols","If there are no subprotocols, a message is displayed and an empty result returned:"},
			PlotSubprotocols[
				Object[Protocol, HPLC, "HPLC protocol 2 for PlotSubprotocols tests"<>$SessionUUID]
			],
			Null,
			Messages:>{PlotSubprotocols::NoSubprotocols}
		]
	},

	SymbolSetUp :> (
		(*generic teardown*)
		Module[{objs, existingObjs},
			objs = Quiet[
				Cases[
					Flatten[{
						Object[Protocol, HPLC, "HPLC protocol 1 for PlotSubprotocols tests"<>$SessionUUID],
						Object[Protocol, HPLC, "HPLC protocol 2 for PlotSubprotocols tests"<>$SessionUUID],
						Object[Protocol, ManualSamplePreparation, "ManualSamplePreparation protocol 1 for PlotSubprotocols tests"<>$SessionUUID],
						Object[Protocol, ManualSamplePreparation, "ManualSamplePreparation protocol 2 for PlotSubprotocols tests"<>$SessionUUID],
						Object[Protocol, ManualSamplePreparation, "ManualSamplePreparation protocol 3 for PlotSubprotocols tests"<>$SessionUUID],
						Object[Protocol, ManualSamplePreparation, "ManualSamplePreparation protocol 4 for PlotSubprotocols tests"<>$SessionUUID],
						Object[Protocol, ImageSample, "ImageSample protocol 1 for PlotSubprotocols tests"<>$SessionUUID],
						Object[Protocol, ImageSample, "ImageSample protocol 2 for PlotSubprotocols tests"<>$SessionUUID],
						Object[Protocol, StockSolution, "StockSolution protocol 1 for PlotSubprotocols tests"<>$SessionUUID],
						Object[Protocol, StockSolution, "StockSolution protocol 2 for PlotSubprotocols tests"<>$SessionUUID],
						Object[Protocol, AdjustpH, "AdjustpH protocol 1 for PlotSubprotocols tests"<>$SessionUUID],
						Object[Protocol, AdjustpH, "AdjustpH protocol 2 for PlotSubprotocols tests"<>$SessionUUID],
						Object[Protocol, MeasurepH, "MeasurepH protocol 1 for PlotSubprotocols tests"<>$SessionUUID],
						Object[Protocol, MeasurepH, "MeasurepH protocol 2 for PlotSubprotocols tests"<>$SessionUUID],
						Object[Protocol, Transfer, "Transfer protocol 1 for PlotSubprotocols tests"<>$SessionUUID],
						Object[Protocol, Transfer, "Transfer protocol 2 for PlotSubprotocols tests"<>$SessionUUID],
						Object[Protocol, MeasureWeight, "MeasureWeight protocol 1 for PlotSubprotocols tests"<>$SessionUUID],
						Object[Protocol, MeasureWeight, "MeasureWeight protocol 2 for PlotSubprotocols tests"<>$SessionUUID],
						Object[Protocol, MeasureWeight, "MeasureWeight protocol 3 for PlotSubprotocols tests"<>$SessionUUID],
						Object[Protocol, MeasureWeight, "MeasureWeight protocol 4 for PlotSubprotocols tests"<>$SessionUUID]
					}],
					ObjectP[]
				]
			];
			existingObjs = PickList[objs, DatabaseMemberQ[objs]];
			EraseObject[existingObjs, Force -> True, Verbose -> False]
		];

		(* set up sample graph *)
		Module[
			{
				protocol1, protocol2, protocol3, protocol4, protocol5, protocol6,
				protocol7, protocol8, protocol9, protocol10, protocol11, protocol12,
				protocol13, protocol14, protocol15, protocol16, protocol17,
				protocol18, protocol19, protocol20
			},

			(* reserveIDs *)
			{
				protocol1, protocol2,
				protocol3, protocol4, protocol5, protocol6,
				protocol7, protocol8,
				protocol9, protocol10,
				protocol11, protocol12,
				protocol13, protocol14,
				protocol15, protocol16,
				protocol17, protocol18, protocol19, protocol20
			}= CreateID[
				Join[
					ConstantArray[Object[Protocol, HPLC], 2],
					ConstantArray[Object[Protocol, ManualSamplePreparation], 4],
					ConstantArray[Object[Protocol, ImageSample], 2],
					ConstantArray[Object[Protocol, StockSolution],2],
					ConstantArray[Object[Protocol, AdjustpH],2],
					ConstantArray[Object[Protocol, MeasurepH],2],
					ConstantArray[Object[Protocol, Transfer],2],
					ConstantArray[Object[Protocol, MeasureWeight], 4]
				]
			];

			(* upload the proper subprotocol and status - check that all scenerios work as expected *)
			Upload[{
				(* Large HPLC - has Aborted and Troubleshooting protocols*)
				Association[Object -> protocol1, Name -> "HPLC protocol 1 for PlotSubprotocols tests"<>$SessionUUID, DeveloperObject-> True, Status -> Processing, OperationStatus -> OperatorProcessing, ParentProtocol -> Null],
				(* MSP subs of the parent HPLC 1 *)
				Association[Object -> protocol3, Name -> "ManualSamplePreparation protocol 1 for PlotSubprotocols tests"<>$SessionUUID, DeveloperObject-> True, Status -> Processing, OperationStatus -> OperatorProcessing, ParentProtocol -> Link[protocol1, Subprotocols]],
				(*ImageSample sub of HPLC 1, and of MSPs *)
				Association[Object -> protocol7, Name -> "ImageSample protocol 1 for PlotSubprotocols tests"<>$SessionUUID, DeveloperObject-> True, Status -> Completed, OperationStatus -> None, ParentProtocol -> Link[protocol1, Subprotocols]],
				Association[Object -> protocol8, Name -> "ImageSample protocol 2 for PlotSubprotocols tests"<>$SessionUUID, DeveloperObject-> True, Status -> Completed, OperationStatus -> None, ParentProtocol -> Link[protocol3, Subprotocols]],
				(*stock solution subs for MSP*)
				Association[Object -> protocol10, Name -> "StockSolution protocol 2 for PlotSubprotocols tests"<>$SessionUUID, DeveloperObject-> True, Status -> Processing, OperationStatus -> OperatorProcessing, ParentProtocol -> Link[protocol3, Subprotocols]],
				(* adjustpH subs *)
				Association[Object -> protocol11, Name -> "AdjustpH protocol 1 for PlotSubprotocols tests"<>$SessionUUID, DeveloperObject-> True, Status -> Aborted, OperationStatus -> None, ParentProtocol -> Link[protocol10, Subprotocols]],
				Association[Object -> protocol12, Name -> "AdjustpH protocol 2 for PlotSubprotocols tests"<>$SessionUUID, DeveloperObject-> True, Status -> Processing, OperationStatus -> OperatorProcessing, ParentProtocol -> Link[protocol10, Subprotocols]],
				(* measure pH and transfer subs for adjust pH *)
				Association[Object -> protocol13, Name -> "MeasurepH protocol 1 for PlotSubprotocols tests"<>$SessionUUID, DeveloperObject-> True, Status -> Completed, OperationStatus -> None, ParentProtocol -> Link[protocol12, Subprotocols]],
				Association[Object -> protocol15, Name -> "Transfer protocol 1 for PlotSubprotocols tests"<>$SessionUUID, DeveloperObject-> True, Status -> Completed, OperationStatus -> None, ParentProtocol -> Link[protocol12, Subprotocols]],
				Association[Object -> protocol14, Name -> "MeasurepH protocol 2 for PlotSubprotocols tests"<>$SessionUUID, DeveloperObject-> True, Status -> Completed, OperationStatus -> None, ParentProtocol -> Link[protocol12, Subprotocols]],
				Association[Object -> protocol16, Name -> "Transfer protocol 2 for PlotSubprotocols tests"<>$SessionUUID, DeveloperObject-> True, Status -> Processing, OperationStatus -> OperatorReady, ParentProtocol -> Link[protocol12, Subprotocols]],
				(*some random measure weights completed*)
				Association[Object -> protocol17, Name -> "MeasureWeight protocol 1 for PlotSubprotocols tests"<>$SessionUUID, DeveloperObject-> True, Status -> Completed, OperationStatus -> None, ParentProtocol -> Link[protocol15, Subprotocols]],
				Association[Object -> protocol18, Name -> "MeasureWeight protocol 2 for PlotSubprotocols tests"<>$SessionUUID, DeveloperObject-> True, Status -> Completed, OperationStatus -> None, ParentProtocol -> Link[protocol15, Subprotocols]],

				(*Awaiting Materials*)
				Association[Object -> protocol4, Name -> "ManualSamplePreparation protocol 2 for PlotSubprotocols tests"<>$SessionUUID, DeveloperObject-> True, Status -> Completed, OperationStatus -> None, ParentProtocol -> Null],
				Association[Object -> protocol19, Name -> "MeasureWeight protocol 3 for PlotSubprotocols tests"<>$SessionUUID, DeveloperObject-> True, Status -> ShippingMaterials, OperationStatus -> None, ParentProtocol -> Link[protocol4, Subprotocols]],

				(*InstrumentProcessing*)
				Association[Object -> protocol5, Name -> "ManualSamplePreparation protocol 3 for PlotSubprotocols tests"<>$SessionUUID, DeveloperObject-> True, Status -> Processing, OperationStatus -> None, ParentProtocol -> Null],
				Association[Object -> protocol9, Name -> "StockSolution protocol 1 for PlotSubprotocols tests"<>$SessionUUID, DeveloperObject-> True, Status -> Processing, OperationStatus -> InstrumentProcessing, ParentProtocol -> Link[protocol5, Subprotocols]],

				(*OperatorReady *)
				Association[Object -> protocol6, Name -> "ManualSamplePreparation protocol 4 for PlotSubprotocols tests"<>$SessionUUID, DeveloperObject-> True, Status -> Processing, OperationStatus -> Troubleshooting, ParentProtocol -> Null],
				Association[Object -> protocol20, Name -> "MeasureWeight protocol 4 for PlotSubprotocols tests"<>$SessionUUID, DeveloperObject-> True, Status -> Processing, OperationStatus -> Troubleshooting, ParentProtocol -> Link[protocol6, Subprotocols]],

				(*no subs*)
				Association[Object -> protocol2, Name -> "HPLC protocol 2 for PlotSubprotocols tests"<>$SessionUUID, DeveloperObject-> True, Status -> Processing, OperationStatus -> OperatorStart, ParentProtocol -> Null]
			}];
		]
	),
	SymbolTearDown :> (
		Module[{objs, existingObjs},
			objs = Quiet[Cases[Flatten[{
				Object[Protocol, HPLC, "HPLC protocol 1 for PlotSubprotocols tests"<>$SessionUUID],
				Object[Protocol, HPLC, "HPLC protocol 2 for PlotSubprotocols tests"<>$SessionUUID],
				Object[Protocol, ManualSamplePreparation, "ManualSamplePreparation protocol 1 for PlotSubprotocols tests"<>$SessionUUID],
				Object[Protocol, ManualSamplePreparation, "ManualSamplePreparation protocol 2 for PlotSubprotocols tests"<>$SessionUUID],
				Object[Protocol, ManualSamplePreparation, "ManualSamplePreparation protocol 3 for PlotSubprotocols tests"<>$SessionUUID],
				Object[Protocol, ManualSamplePreparation, "ManualSamplePreparation protocol 4 for PlotSubprotocols tests"<>$SessionUUID],
				Object[Protocol, ImageSample, "ImageSample protocol 1 for PlotSubprotocols tests"<>$SessionUUID],
				Object[Protocol, ImageSample, "ImageSample protocol 2 for PlotSubprotocols tests"<>$SessionUUID],
				Object[Protocol, StockSolution, "StockSolution protocol 1 for PlotSubprotocols tests"<>$SessionUUID],
				Object[Protocol, StockSolution, "StockSolution protocol 2 for PlotSubprotocols tests"<>$SessionUUID],
				Object[Protocol, AdjustpH, "AdjustpH protocol 1 for PlotSubprotocols tests"<>$SessionUUID],
				Object[Protocol, AdjustpH, "AdjustpH protocol 2 for PlotSubprotocols tests"<>$SessionUUID],
				Object[Protocol, MeasurepH, "MeasurepH protocol 1 for PlotSubprotocols tests"<>$SessionUUID],
				Object[Protocol, MeasurepH, "MeasurepH protocol 2 for PlotSubprotocols tests"<>$SessionUUID],
				Object[Protocol, Transfer, "Transfer protocol 1 for PlotSubprotocols tests"<>$SessionUUID],
				Object[Protocol, Transfer, "Transfer protocol 2 for PlotSubprotocols tests"<>$SessionUUID],
				Object[Protocol, MeasureWeight, "MeasureWeight protocol 1 for PlotSubprotocols tests"<>$SessionUUID],
				Object[Protocol, MeasureWeight, "MeasureWeight protocol 2 for PlotSubprotocols tests"<>$SessionUUID],
				Object[Protocol, MeasureWeight, "MeasureWeight protocol 3 for PlotSubprotocols tests"<>$SessionUUID],
				Object[Protocol, MeasureWeight, "MeasureWeight protocol 4 for PlotSubprotocols tests"<>$SessionUUID]
			}],
				ObjectP[]
			]];
			existingObjs = PickList[objs, DatabaseMemberQ[objs]];
			EraseObject[existingObjs, Force -> True, Verbose -> False]
		]
	)
];

