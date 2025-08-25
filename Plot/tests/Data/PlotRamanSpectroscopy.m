(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsection:: *)
(*PlotRamanSpectroscopy*)


DefineTests[PlotRamanSpectroscopy,
	{
		(* -- BASIC -- *)
		Example[{Basic,"Given a RamanSpectroscopy data object, creates plots for the AverageRamanSpectrum as well as the spectra and positions collected at each sampling position:"},
			PlotRamanSpectroscopy[
				Object[Data, RamanSpectroscopy, "PlotRamanSpectroscopy sample data"<>$SessionUUID]
			],
			_TabView
		],
		Example[{Basic,"Plot a list of RamanSpectroscopy data objects:"},
			PlotRamanSpectroscopy[
				Repeat[Object[Data, RamanSpectroscopy, "PlotRamanSpectroscopy sample data"<>$SessionUUID], 3]
			],
			TabView[{(_String->_TabView)..}, ___]
		],
		Example[{Basic,"Given a RamanSpectroscopy protocol object, creates plots of the linked data objects:"},
			PlotRamanSpectroscopy[
				Object[Protocol, RamanSpectroscopy, "PlotRamanSpectroscopy sample protocol"<>$SessionUUID]
			],
			_TabView
		],

		(* -- OPTIONS -- *)
		Example[{Options, ReduceData, "Indicate that the number of spectra should be reduced when a dense sampling pattern was used:"},
			output = PlotRamanSpectroscopy[
				Object[Data, RamanSpectroscopy, "PlotRamanSpectroscopy sample data"<>$SessionUUID],
				ReduceData -> True
			];
			Values[output[[1]]],
			{ValidGraphicsP[]..},
			Variables :> {output}
		],
		Example[{Options, OutputFormat, "Set the output format:"},
			output = PlotRamanSpectroscopy[
				Object[Data, RamanSpectroscopy, "PlotRamanSpectroscopy sample data"<>$SessionUUID],
				OutputFormat -> Average
			];
			output,
			ValidGraphicsP[],
			Variables :> {output}
		],
		Example[{Options, ImageSize, "Set the image size for the output plots:"},
			output = PlotRamanSpectroscopy[
				Object[Data, RamanSpectroscopy, "PlotRamanSpectroscopy sample data"<>$SessionUUID],
				ImageSize -> 800
			];
			Values[output[[1]]],
			{ValidGraphicsP[]..},
			Variables :> {output}
		]
	},

	(*  build test objects *)
	Stubs:>{
		$EmailEnabled=False
	},
	SymbolSetUp :> (
		$CreatedObjects = {};
		Module[{objs, existingObjs},
			objs = Quiet[Cases[
				Flatten[{
					Object[Data, RamanSpectroscopy, "PlotRamanSpectroscopy sample data"],
					Object[Protocol, RamanSpectroscopy, "PlotRamanSpectroscopy sample protocol"]
				}],
				ObjectP[]
			]];
			existingObjs = PickList[objs, DatabaseMemberQ[objs]];
			EraseObject[existingObjs, Force -> True, Verbose -> False]
		];
		Block[{$AllowSystemsProtocols = True},
			Module[
				{
					rawRamanData, ramanDataQA1, ramanDataQA2, ramanDataQA3, ramanPositions, ramanProtocol, dataObject1, ramanProtocol1
				},
				(* -- FAKE RAMAN DATA -- *)
				(*make some believable looking raman data*)
				rawRamanData =
						Quiet[
							Table[
								Plus[
									11*Exp[-(x + 100)^2/1000],
									22*Exp[-(x - 100)^2/1000],
									10*Exp[-(x + 180)^2/1000],
									20*Exp[-(x - 180)^2/1000],
									25*Exp[-(x - 250)^2/1000],
									22*Exp[-(x - 420)^2/1000],
									60*Exp[-(x - 800)^2/100],
									65*Exp[-(x - 1700)^2/100],
									30*Exp[-(x - 2200)^2/100],
									RandomReal[{0, 2}]
								],
								{x, -300, 2500}
							]
						];

				(*make quantity arrays so they can be uploaded*)
				ramanDataQA1 = QuantityArray[Transpose[{N[Range[-300, 2500]], rawRamanData}], {1/Centimeter, ArbitraryUnit}];
				ramanDataQA2 = QuantityArray[Transpose[{N[Range[-300, 2500]], 1.2*rawRamanData}], {1/Centimeter, ArbitraryUnit}];
				ramanDataQA3 = QuantityArray[Transpose[{N[Range[-300, 2500]], 0.7*rawRamanData}], {1/Centimeter, ArbitraryUnit}];

				(* -- FAKE RAMAN POSITIONS -- *)
				(*simulate measurement positions*)
				ramanPositions = Table[{RandomReal[{-1000,1000}], RandomReal[{-1000,1000}],RandomReal[{-100,100}]}*Micrometer, 15];

				(* -- FAKE RAMAN DATA OBJECT -- *)
				dataObject1 = Upload[<|
					Type -> Object[Data, RamanSpectroscopy],
					Name -> "PlotRamanSpectroscopy sample data"<>$SessionUUID,
					Replace[AverageRamanSpectrum] -> ramanDataQA1,
					Replace[RamanSpectra] -> Join[ConstantArray[ramanDataQA1, 5], ConstantArray[ramanDataQA2, 5], ConstantArray[ramanDataQA3, 5]],
					Replace[MeasurementPositions]-> ramanPositions
				|>];

				ramanProtocol1 = Upload[<|
					Type -> Object[Protocol, RamanSpectroscopy],
					Name -> "PlotRamanSpectroscopy sample protocol"<>$SessionUUID,
					Replace[Data] -> {Link[dataObject1, Protocol]}
				|>]
			]
		]
	),
	SymbolTearDown:>(
		EraseObject[PickList[$CreatedObjects, DatabaseMemberQ[$CreatedObjects], True], Force -> True, Verbose -> False];
	)
];
